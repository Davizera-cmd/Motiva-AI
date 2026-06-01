'use strict';

class IAProvider {
  async generate(prompt) {
    throw new Error('Método generate deve ser implementado');
  }
}

module.exports = { IAProvider };
