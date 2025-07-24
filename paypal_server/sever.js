const express = require('express');
const axios = require('axios');
const cors = require('cors');
require('dotenv').config();

const app = express();
app.use(cors());
app.use(express.json());

const PAYPAL_API = 'https://api-m.sandbox.paypal.com'; // Dùng sandbox
const CLIENT = process.env.PAYPAL_CLIENT_ID;
const SECRET = process.env.PAYPAL_SECRET;

app.post('/create-payment', async (req, res) => {
  const { total } = req.body;

  try {
    // Lấy access token từ PayPal
    const tokenResponse = await axios({
      url: `${PAYPAL_API}/v1/oauth2/token`,
      method: 'post',
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      auth: {
        username: CLIENT,
        password: SECRET,
      },
      data: 'grant_type=client_credentials',
    });

    const accessToken = tokenResponse.data.access_token;

    // Tạo order
    const orderResponse = await axios({
      url: `${PAYPAL_API}/v2/checkout/orders`,
      method: 'post',
      headers: {
        Authorization: `Bearer ${accessToken}`,
        'Content-Type': 'application/json',
      },
      data: {
        intent: 'CAPTURE',
        purchase_units: [{
          amount: {
            currency_code: 'USD',
            value: total
          }
        }],
        application_context: {
          return_url: 'https://example.com/success',
          cancel_url: 'https://example.com/cancel'
        }
      }
    });

    res.json({ id: orderResponse.data.id });
  } catch (error) {
    console.error(error);
    res.status(500).send('Something went wrong');
  }
});

app.listen(5000, () => {
  console.log('Server is running on http://localhost:5000');
});
