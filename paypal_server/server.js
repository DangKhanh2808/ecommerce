const express = require('express');
const axios = require('axios');
const cors = require('cors');
require('dotenv').config();

const app = express();
const PORT = 3000;

// Middleware
app.use(cors());
app.use(express.json());

// Logging middleware
app.use((req, res, next) => {
  console.log(`📨 ${new Date().toISOString()} - ${req.method} ${req.url}`);
  if (req.body && Object.keys(req.body).length > 0) {
    console.log('📦 Request Body:', JSON.stringify(req.body, null, 2));
  }
  next();
});

// PayPal configuration
const PAYPAL_API = 'https://api-m.sandbox.paypal.com';
const CLIENT_ID = process.env.PAYPAL_CLIENT_ID;
const CLIENT_SECRET = process.env.PAYPAL_SECRET;

console.log('🔑 PayPal Configuration:');
console.log('   Client ID:', CLIENT_ID ? '✅ Set' : '❌ Missing');
console.log('   Client Secret:', CLIENT_SECRET ? '✅ Set' : '❌ Missing');

// Health check endpoint
app.get('/', (req, res) => {
  res.json({
    status: 'OK',
    message: 'PayPal Server is running!',
    timestamp: new Date().toISOString(),
    endpoints: {
      createPayment: 'POST /create-payment',
      success: 'GET /paypal-success',
      cancel: 'GET /paypal-cancel'
    }
  });
});

// Create PayPal payment
app.post('/create-payment', async (req, res) => {
  try {
    const { total } = req.body;
    
    console.log('💰 Creating payment for amount:', total);

    // Validate input
    if (!total || isNaN(total) || total <= 0) {
      console.log('❌ Invalid amount:', total);
      return res.status(400).json({
        error: 'Invalid amount',
        message: 'Amount must be a positive number'
      });
    }

    // Get PayPal access token
    console.log('🔑 Getting PayPal access token...');
    const tokenResponse = await axios({
      url: `${PAYPAL_API}/v1/oauth2/token`,
      method: 'post',
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      auth: {
        username: CLIENT_ID,
        password: CLIENT_SECRET,
      },
      data: 'grant_type=client_credentials',
    });

    const accessToken = tokenResponse.data.access_token;
    console.log('✅ Access token received');

    // Create PayPal order
    console.log('📦 Creating PayPal order...');
    const orderData = {
      intent: 'CAPTURE',
      purchase_units: [{
        amount: {
          currency_code: 'USD',
          value: total.toString()
        },
        description: 'E-commerce Order'
      }],
              application_context: {
          return_url: `http://172.20.10.9:${PORT}/paypal-success?total=${total}`,
          cancel_url: `http://172.20.10.9:${PORT}/paypal-cancel`,
          brand_name: 'E-commerce Store',
          landing_page: 'LOGIN',
          user_action: 'PAY_NOW'
        }
    };

    console.log('📋 Order data:', JSON.stringify(orderData, null, 2));

    const orderResponse = await axios({
      url: `${PAYPAL_API}/v2/checkout/orders`,
      method: 'post',
      headers: {
        Authorization: `Bearer ${accessToken}`,
        'Content-Type': 'application/json',
      },
      data: orderData
    });

    const orderId = orderResponse.data.id;
    console.log('✅ PayPal order created successfully:', orderId);
    
    res.json({
      success: true,
      id: orderId,
      message: 'Payment order created successfully'
    });

  } catch (error) {
    console.error('❌ PayPal Error:', error.response?.data || error.message);
    
    let errorMessage = 'Payment creation failed';
    let errorDetails = error.message;

    if (error.response?.data) {
      errorMessage = error.response.data.message || errorMessage;
      errorDetails = JSON.stringify(error.response.data);
    }

    res.status(500).json({
      success: false,
      error: errorMessage,
      details: errorDetails
    });
  }
});

// PayPal success page
app.get('/paypal-success', (req, res) => {
  const total = req.query.total;
  console.log('✅ Payment successful for amount:', total);
  
  res.send(`
    <!DOCTYPE html>
    <html>
    <head>
      <title>Thanh toán thành công</title>
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <style>
        * {
          margin: 0;
          padding: 0;
          box-sizing: border-box;
        }
        
        body {
          font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
          background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
          min-height: 100vh;
          display: flex;
          align-items: center;
          justify-content: center;
          padding: 20px;
        }
        
        .container {
          background: white;
          border-radius: 20px;
          padding: 40px;
          text-align: center;
          box-shadow: 0 20px 40px rgba(0,0,0,0.1);
          max-width: 400px;
          width: 100%;
        }
        
        .success-icon {
          width: 80px;
          height: 80px;
          background: #28a745;
          border-radius: 50%;
          display: flex;
          align-items: center;
          justify-content: center;
          margin: 0 auto 20px;
          animation: bounce 1s ease-in-out;
        }
        
        .success-icon::after {
          content: '✓';
          color: white;
          font-size: 40px;
          font-weight: bold;
        }
        
        @keyframes bounce {
          0%, 20%, 50%, 80%, 100% {
            transform: translateY(0);
          }
          40% {
            transform: translateY(-10px);
          }
          60% {
            transform: translateY(-5px);
          }
        }
        
        h1 {
          color: #28a745;
          font-size: 28px;
          margin-bottom: 15px;
          font-weight: 600;
        }
        
        .message {
          color: #666;
          font-size: 16px;
          margin-bottom: 20px;
          line-height: 1.5;
        }
        
        .amount {
          background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
          color: white;
          padding: 15px 25px;
          border-radius: 25px;
          font-size: 24px;
          font-weight: bold;
          margin: 20px 0;
          display: inline-block;
        }
        
        .return-btn {
          background: #28a745;
          color: white;
          border: none;
          padding: 12px 30px;
          border-radius: 25px;
          font-size: 16px;
          cursor: pointer;
          margin-top: 20px;
          transition: all 0.3s ease;
        }
        
        .return-btn:hover {
          background: #218838;
          transform: translateY(-2px);
        }
        
        .countdown {
          color: #999;
          font-size: 14px;
          margin-top: 15px;
        }
        
        .progress-bar {
          width: 100%;
          height: 4px;
          background: #eee;
          border-radius: 2px;
          margin-top: 10px;
          overflow: hidden;
        }
        
        .progress-fill {
          height: 100%;
          background: #28a745;
          width: 100%;
          animation: progress 3s linear;
        }
        
        @keyframes progress {
          from { width: 100%; }
          to { width: 0%; }
        }
      </style>
    </head>
    <body>
      <div class="container">
        <div class="success-icon"></div>
        <h1>Thanh toán thành công!</h1>
        <p class="message">Đơn hàng của bạn đã được xử lý thành công.</p>
        <div class="amount">$${total}</div>
        <p class="message">Cảm ơn bạn đã mua hàng!</p>
        
        <div class="progress-bar">
          <div class="progress-fill"></div>
        </div>
        <p class="countdown">Tự động đóng sau <span id="timer">3</span> giây</p>
        
        <button class="return-btn" onclick="closeWindow()">Quay lại ứng dụng</button>
      </div>
      
      <script>
        let timeLeft = 3;
        const timerElement = document.getElementById('timer');
        
        const countdown = setInterval(() => {
          timeLeft--;
          timerElement.textContent = timeLeft;
          
          if (timeLeft <= 0) {
            clearInterval(countdown);
            closeWindow();
          }
        }, 1000);
        
        function closeWindow() {
          // Thử đóng cửa sổ
          window.close();
          
          // Nếu không đóng được, chuyển về app
          setTimeout(() => {
            window.location.href = 'ecommerce://payment-success?total=${total}';
          }, 500);
        }
      </script>
    </body>
    </html>
  `);
});

// PayPal cancel page
app.get('/paypal-cancel', (req, res) => {
  console.log('❌ Payment cancelled by user');
  
  res.send(`
    <!DOCTYPE html>
    <html>
    <head>
      <title>Thanh toán bị hủy</title>
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <style>
        * {
          margin: 0;
          padding: 0;
          box-sizing: border-box;
        }
        
        body {
          font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
          background: linear-gradient(135deg, #ff6b6b 0%, #ee5a24 100%);
          min-height: 100vh;
          display: flex;
          align-items: center;
          justify-content: center;
          padding: 20px;
        }
        
        .container {
          background: white;
          border-radius: 20px;
          padding: 40px;
          text-align: center;
          box-shadow: 0 20px 40px rgba(0,0,0,0.1);
          max-width: 400px;
          width: 100%;
        }
        
        .cancel-icon {
          width: 80px;
          height: 80px;
          background: #dc3545;
          border-radius: 50%;
          display: flex;
          align-items: center;
          justify-content: center;
          margin: 0 auto 20px;
          animation: shake 0.5s ease-in-out;
        }
        
        .cancel-icon::after {
          content: '✕';
          color: white;
          font-size: 40px;
          font-weight: bold;
        }
        
        @keyframes shake {
          0%, 100% { transform: translateX(0); }
          25% { transform: translateX(-5px); }
          75% { transform: translateX(5px); }
        }
        
        h1 {
          color: #dc3545;
          font-size: 28px;
          margin-bottom: 15px;
          font-weight: 600;
        }
        
        .message {
          color: #666;
          font-size: 16px;
          margin-bottom: 20px;
          line-height: 1.5;
        }
        
        .retry-btn {
          background: #dc3545;
          color: white;
          border: none;
          padding: 12px 30px;
          border-radius: 25px;
          font-size: 16px;
          cursor: pointer;
          margin-top: 20px;
          transition: all 0.3s ease;
        }
        
        .retry-btn:hover {
          background: #c82333;
          transform: translateY(-2px);
        }
        
        .countdown {
          color: #999;
          font-size: 14px;
          margin-top: 15px;
        }
        
        .progress-bar {
          width: 100%;
          height: 4px;
          background: #eee;
          border-radius: 2px;
          margin-top: 10px;
          overflow: hidden;
        }
        
        .progress-fill {
          height: 100%;
          background: #dc3545;
          width: 100%;
          animation: progress 3s linear;
        }
        
        @keyframes progress {
          from { width: 100%; }
          to { width: 0%; }
        }
      </style>
    </head>
    <body>
      <div class="container">
        <div class="cancel-icon"></div>
        <h1>Thanh toán bị hủy</h1>
        <p class="message">Bạn đã hủy quá trình thanh toán.</p>
        <p class="message">Bạn có thể thử lại từ ứng dụng.</p>
        
        <div class="progress-bar">
          <div class="progress-fill"></div>
        </div>
        <p class="countdown">Tự động đóng sau <span id="timer">3</span> giây</p>
        
        <button class="retry-btn" onclick="closeWindow()">Quay lại ứng dụng</button>
      </div>
      
      <script>
        let timeLeft = 3;
        const timerElement = document.getElementById('timer');
        
        const countdown = setInterval(() => {
          timeLeft--;
          timerElement.textContent = timeLeft;
          
          if (timeLeft <= 0) {
            clearInterval(countdown);
            closeWindow();
          }
        }, 1000);
        
        function closeWindow() {
          // Thử đóng cửa sổ
          window.close();
          
          // Nếu không đóng được, chuyển về app
          setTimeout(() => {
            window.location.href = 'yourapp://payment-cancelled';
          }, 500);
        }
      </script>
    </body>
    </html>
  `);
});

// Error handling middleware
app.use((error, req, res, next) => {
  console.error('❌ Server Error:', error);
  res.status(500).json({
    success: false,
    error: 'Internal server error',
    message: error.message
  });
});

// Start server
app.listen(PORT, '0.0.0.0', () => {
  console.log('🚀 PayPal Server started successfully!');
  console.log(`📍 Local: http://localhost:${PORT}`);
  console.log(`🌐 Network: http://172.20.10.9:${PORT}`);
  console.log('📋 Available endpoints:');
  console.log('   GET  / - Health check');
  console.log('   POST /create-payment - Create payment');
  console.log('   GET  /paypal-success - Success page');
  console.log('   GET  /paypal-cancel - Cancel page');
}); 