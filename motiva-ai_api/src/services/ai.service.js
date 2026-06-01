'use strict';

const { GeminiProvider } = require('./gemini-provider');
const { OpenRouterProvider } = require('./openrouter-provider');

class AIService {
  static getProvider() {
    const useGemini = process.env.USE_GEMINI === 'true';
    if (useGemini) {
      return new GeminiProvider(
        process.env.GEMINI_API_KEY,
        process.env.GEMINI_MODEL
      );
    }
    return new OpenRouterProvider(
      process.env.OPENROUTER_API_KEY,
      process.env.OPENROUTER_MODEL
    );
  }

  static async generateMotivationalMessage(addictionType, aiPrompt, daysAbstinent) {
    const provider = AIService.getProvider();
    const prompt = `Você é um assistente motivacional amigável chamado Motiva-AI. 
    Escreva uma mensagem de apoio curta (1 ou 2 frases) para um usuário que está tentando 
    superar o vício em "${addictionType}". O usuário está em abstinência há ${daysAbstinent} dias. 
    O tom da mensagem deve ser: "${aiPrompt}". Seja direto e inspirador. 
    Não use markdown ou formatação especial. Não inclua saudações como "Olá!" ou "Oi!".`;

    try {
      const message = await provider.generate(prompt);
      return message || AIService._fallbackMessage(addictionType);
    } catch (err) {
      console.error('Erro no provedor de IA:', err.message);
      return AIService._fallbackMessage(addictionType);
    }
  }

  static _fallbackMessage(addictionType) {
    const messages = [
      `Cada dia longe de ${addictionType} é uma vitória que ninguém pode tirar de você.`,
      `Você já provou que é capaz. Continue firme na sua jornada!`,
      `A força que você tem dentro é maior do que qualquer vício. Acredite.`,
    ];
    return messages[Math.floor(Math.random() * messages.length)];
  }
}

module.exports = { AIService };
