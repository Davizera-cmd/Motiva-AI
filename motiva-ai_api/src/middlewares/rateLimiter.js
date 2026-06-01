'use strict';
const { rateLimit } = require('express-rate-limit');

const dailyMotivationLimiter = rateLimit({
  windowMs: process.env.NODE_ENV === 'development' ? 60 * 1000 : 24 * 60 * 60 * 1000, 
  max: process.env.NODE_ENV === 'development' ? 100 : 1,                          
  standardHeaders: 'draft-7',            
  legacyHeaders: false,
  message: {
    error: 'RATE_LIMIT_EXCEEDED',
    message: 'Você já recebeu sua mensagem motivacional hoje. Volte amanhã! 💪',
  },

  keyGenerator: (req) => {
    const forwarded = req.headers['x-forwarded-for']?.split(',')[0]?.trim();
    return forwarded ?? req.ip;
  },
});

module.exports = { dailyMotivationLimiter };
