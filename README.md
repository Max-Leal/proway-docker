# 🚀 Desafio DevOps: Recuperação do "Pizzaria App" (+Devs2blu)

Este repositório documenta a minha solução para um desafio prático do programa +Devs2blu: pegar uma aplicação de pizzaria abandonada, diagnosticar os problemas e implantá-la de forma containerizada e automatizada.

---

### Desafio (O Ponto de Partida)

O projeto foi entregue com o backend não funcional e um ficheiro `README.md` com as seguintes "Pendências Técnicas":
* Criar o `Dockerfile` para o projeto Backend (Python 3.9).
* Instalar os pacotes Python necessários.
* Expor a porta 5000.
* Montar um `docker-compose.yml` para orquestrar o frontend e o backend.

---

### A Minha Solução (O Foco DevOps)

Com um prazo de apenas 2 dias, foquei não apenas em resolver o problema, mas em criar uma solução automatizada e robusta.

1.  **Containerização:** Criei o `Dockerfile` para o backend Python/Flask e os ficheiros `docker-compose.yml` (`pizza.yml`, `pizza2.yml`) para orquestrar os serviços da aplicação, resolvendo as pendências técnicas.

2.  **Automação com Script Idempotente:** Como diferencial, desenvolvi o `projeto_pizza.sh`, um script em Bash que automatiza todo o processo de build e deploy.
    * **Idempotência:** O script verifica o que já foi feito (ex: se os containers já existem) antes de executar comandos, garantindo que ele possa ser rodado múltiplas vezes sem erros.
    * **Adaptação:** O script foi inicialmente desenvolvido para Debian e posteriormente adaptado para ser executado em ambientes **Amazon Linux (AWS)**, demonstrando flexibilidade em diferentes sistemas operacionais.

---

### 🛠️ Tecnologias Utilizadas

* **Aplicação:** Python, Vue.js, HTML, CSS
* **DevOps (Minha Contribuição):**
    <p>
      <img src="https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white" alt="Docker">
      <img src="https://img.shields.io/badge/Docker_Compose-2496ED?style=for-the-badge&logo=docker&logoColor=white" alt="Docker Compose">
      <img src="https://img.shields.io/badge/Bash-4EAA25?style=for-the-badge&logo=gnu-bash&logoColor=white" alt="Bash">
      <img src="https://img.shields.io/badge/GIT-E44C30?style=for-the-badge&logo=git&logoColor=white" alt="Git">
    </p>

---

### 🏁 Como Executar o Projeto

Para rodar este projeto localmente, basta ter o **Git** e o **Docker** (com Docker Compose) instalados.

1.  Clone o repositório:
    ```bash
    git clone [https://github.com/BryanPacker/proway-docker.git](https://github.com/BryanPacker/proway-docker.git)
    cd proway-docker
    ```

2.  Dê permissão de execução ao script de automação:
    ```bash
    chmod +x projeto_pizza.sh
    ```

3.  Execute o script:
    ```bash
    ./projeto_pizza.sh
    ```

A aplicação estará disponível no seu navegador. *(Verifique a porta correta no `projeto_pizza.yml`, atualmente está disponível na `http://localhost:80`)*.

---

### Principais Aprendizados

Este projeto foi uma imersão intensiva em Bash scripting, Docker e na importância de criar automações idempotentes. Finalizar a solução completa dentro do prazo de 2 dias foi um grande aprendizado sobre resolução de problemas sob pressão.
