'use strict';

const { IAProvider } = require('./ai-provider.interface');

class GeminiProvider extends IAProvider {
  constructor(apiKey, model) {
    super();
    this.apiKey = apiKey;
    this.model = model;
  }

  async generate(prompt) {
    const url = `https://generativelanguage.googleapis.com/v1beta/models/${this.model}:generateContent?key=${this.apiKey}`;
    const response = await fetch(url, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        contents: [{
          parts: [{ text: prompt }]
        }]
      }),
    });

    if (!response.ok) {
      const errorBody = await response.text();
      throw new Error(`Gemini API Error ${response.status}: ${errorBody}`);
    }

    const data = await response.json();
    const content = data?.candidates?.[0]?.content?.parts?.[0]?.text?.trim();
    if (!content) {
      console.warn('Gemini retorno sem conteúdo válido:', JSON.stringify(data));
    }
    return content;
  }
}

module.exports = { GeminiProvider };
