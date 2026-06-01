'use strict';

const express  = require('express');
const { dailyMotivationLimiter } = require('../middlewares/rateLimiter');
const { AIService } = require('../services/ai.service');

const router = express.Router();

router.post('/motivate', dailyMotivationLimiter, async (req, res) => {
  const { addictionType, aiPrompt, daysAbstinent } = req.body;

  const validationError = validateMotivateRequest(addictionType, aiPrompt, daysAbstinent);
  if (validationError) {
    return res.status(400).json({ error: 'VALIDATION_ERROR', details: validationError });
  }

  try {
    const message = await AIService.generateMotivationalMessage(
      addictionType.trim(),
      aiPrompt.trim(),
      Number(daysAbstinent)
    );

    console.log(`[/motivate] IP: ${req.ip} | Vício: ${addictionType} | Dias: ${daysAbstinent}`);

    return res.status(200).json({ message });

  } catch (err) {
    console.error('[/motivate] Erro inesperado:', err.message);
    return res.status(500).json({ error: 'INTERNAL_ERROR' });
  }
});

function validateMotivateRequest(addictionType, aiPrompt, daysAbstinent) {
  if (!addictionType || typeof addictionType !== 'string' || !addictionType.trim()) {
    return 'O campo "addictionType" é obrigatório e deve ser uma string não vazia.';
  }
  if (!aiPrompt || typeof aiPrompt !== 'string' || !aiPrompt.trim()) {
    return 'O campo "aiPrompt" é obrigatório e deve ser uma string não vazia.';
  }
  if (daysAbstinent === undefined || daysAbstinent === null || isNaN(Number(daysAbstinent))) {
    return 'O campo "daysAbstinent" é obrigatório e deve ser um número.';
  }
  if (Number(daysAbstinent) < 0) {
    return 'O campo "daysAbstinent" deve ser maior ou igual a zero.';
  }
  return null;
}

module.exports = router;
