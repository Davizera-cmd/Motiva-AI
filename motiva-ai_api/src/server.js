'use strict';
require('dotenv').config();

const express = require('express');
const cors = require('cors');
const motivateRoute = require('./routes/motivate.route');

const app = express();
const PORT = process.env.PORT ?? 3000;

app.use(cors());
app.use(express.json());

app.use('/api', motivateRoute);

app.get('/health', (_req, res) => {
  res.json({ status: 'ok', app: 'Motiva-AI API', timestamp: new Date().toISOString() });
});


app.listen(PORT, () => {
  console.log(`Motiva-AI API rodando na porta ${PORT}`);
});
