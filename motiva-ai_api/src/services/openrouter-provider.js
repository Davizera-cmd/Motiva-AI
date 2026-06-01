'use strict';

const { IAProvider } = require('./ai-provider.interface');

class OpenRouterProvider extends IAProvider {
  constructor(apiKey, model) {
    super();
    this.apiKey = apiKey;
    this.model = model;
  }

  async generate(prompt) {
    const url = 'https://openrouter.ai/api/v1/chat/completions';
    const response = await fetch(url, {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${this.apiKey}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        model: this.model,
        messages: [{ role: 'user', content: prompt }],
        max_tokens: 1000,
      }),
    });

    if (!response.ok) {
      const errorBody = await response.text();
      throw new Error(`OpenRouter API Error ${response.status}: ${errorBody}`);
    }

    const data = await response.json();
    const content = data?.choices?.[0]?.message?.content?.trim();
    if (!content) {
      console.warn('OpenRouter retorno sem conteúdo válido:', JSON.stringify(data));
    }
    return content;
  }
}

module.exports = { OpenRouterProvider };
