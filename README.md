# Nutriela 🥗

Progressive Web App (PWA) offline para acompanhamento nutricional completo. O Nutriela ajuda você a controlar sua alimentação, calcular macros, atingir seus objetivos de fitness e muito mais - tudo sem precisar de internet!

## 🌐 Demo Online

Acesse o app online: [Link do GitHub Pages](https://SEU_USUARIO.github.io/nutriela/)

## 📱 Instalar no Celular

1. Abra o link no navegador do seu celular
2. Clique em "Adicionar à tela inicial" ou "Instalar app"
3. O app funcionará offline após a instalação

## 🚀 Funcionalidades

### ✅ Cadastro Completo do Usuário
- Nome, idade, peso, altura
- Gênero (masculino/feminino)
- Objetivo: perder peso, manter peso ou ganhar músculos
- Nível de atividade física (sedentário a extremamente ativo)

### 📊 Cálculos Automáticos de Nutricionista
- **TMB** (Taxa Metabólica Basal) - Fórmula de Mifflin-St Jeor
- **TDEE** (Total Daily Energy Expenditure)
- **IMC** (Índice de Massa Corporal) com classificação
- **Metas calóricas** baseadas no objetivo
- **Metas de macros** (proteína, carboidratos, gorduras)
- **Meta de água** baseada no peso corporal

### 🍽️ Banco de Dados Offline de Alimentos
- 30+ alimentos comuns pré-cadastrados
- Categorias: Proteínas, Carboidratos, Vegetais, Frutas, Gorduras, Bebidas
- Informações nutricionais completas por 100g
- Sistema de busca rápida
- Seleção por categorias com filtros

### 📅 Acompanhamento Diário
- Registro de refeições (café da manhã, almoço, jantar, lanches)
- Controle de ingestão de água
- Progresso visual de calorias e macros
- Navegação por datas para histórico

### 📈 Dashboard Interativo
- Barras de progresso para calorias e macros
- Resumo das refeições do dia
- Adição rápida de água (250ml por clique)
- Navegação fácil entre datas

###  Perfil do Usuário
- Visualização completa de dados pessoais
- Medidas corporais e IMC
- Metas diárias personalizadas
- Informações metabólicas
- Opção de resetar dados

## 🎨 Interface
- Design moderno e intuitivo
- Mínima digitação necessária (seleção por cliques)
- Emojis para identificação visual rápida
- Cores diferentes para cada macro
- Interface responsiva e fluida

## 🛠️ Tecnologias

- **HTML5/CSS3/JavaScript** - Interface web moderna
- **localStorage** - Armazenamento offline no navegador
- **Service Worker** - Cache para funcionamento offline
- **PWA Manifest** - Instalação como app nativo

## 📦 Como Rodar Localmente

### Opção 1: Servidor Python
```bash
cd "c:/Users/USER-PC/OneDrive/Documentos/Faculdade/Meus projetos iniciantes/Nutricao"
python -m http.server 8000
```
Acesse: `http://localhost:8000`

### Opção 2: Servidor Node.js
```bash
npx http-server -p 8000
```

### Opção 3: Abrir Diretamente
Basta abrir o arquivo `index.html` no navegador (algumas funcionalidades PWA podem não funcionar).

## 📱 Estrutura do Projeto PWA

```
Nutricao/
├── index.html              # Interface principal
├── app.js                  # Lógica do app e localStorage
├── manifest.json           # Manifesto PWA
├── sw.js                   # Service Worker para cache offline
├── icon-192.png            # Ícone 192x192
├── icon-512.png            # Ícone 512x512
└── README.md               # Documentação
```

## 🎯 Como Usar

1. **Primeiro Acesso**: Faça seu cadastro com dados pessoais e objetivos
2. **Dashboard**: Veja seu progresso diário de calorias e macros
3. **Adicionar Refeição**: 
   - Clique em "Adicionar Refeição"
   - Selecione o tipo (café, almoço, jantar, lanche)
   - Escolha alimentos da lista ou busque por nome
   - Ajuste a quantidade em gramas
   - Salve a refeição
4. **Adicionar Água**: Clique no botão "+250ml Água" para adicionar água
5. **Perfil**: Veja seus dados e metas
6. **Navegar pelas Datas**: Use os botões para ver dados de outros dias

## 💾 Armazenamento Offline

Todos os dados são salvos localmente usando localStorage:
- Dados do usuário
- Histórico de refeições
- Ingestão de água
- Não requer conexão com internet
- Funciona como app nativo após instalação

## 🚀 Deploy no GitHub Pages

### Passo 1: Criar Repositório no GitHub
1. Acesse [github.com](https://github.com) e faça login
2. Clique no botão "+" → "New repository"
3. Nome do repositório: `nutriela` (ou outro nome)
4. Marque "Public" para qualquer pessoa acessar
5. Clique em "Create repository"

### Passo 2: Fazer Upload dos Arquivos
1. No repositório criado, clique em "uploading an existing file"
2. Arraste os seguintes arquivos para a área de upload:
   - `index.html`
   - `app.js`
   - `manifest.json`
   - `sw.js`
   - `icon-192.png`
   - `icon-512.png`
   - `README.md`
3. Clique em "Commit changes"

### Passo 3: Ativar GitHub Pages
1. No repositório, vá em Settings → Pages
2. Em "Source", selecione "Deploy from a branch"
3. Branch: `main` (ou `master`)
4. Folder: `/ (root)`
5. Clique em "Save"

### Passo 4: Aguardar Deploy
1. Aguarde cerca de 1-2 minutos
2. A URL do seu app aparecerá no topo da página Pages
3. Exemplo: `https://SEU_USUARIO.github.io/nutriela/`

### Passo 5: Testar
1. Acesse a URL no navegador
2. No celular, acesse a mesma URL
3. O navegador deve oferecer "Instalar app" ou "Adicionar à tela inicial"

## 🔒 Privacidade

- Todos os dados ficam armazenados apenas no seu dispositivo
- Nenhuma informação é enviada para servidores externos
- Você pode resetar todos os dados clicando em "Resetar"

## 🎨 Cores e Macros

- 🟠 **Calorias** - Laranja
- 🔴 **Proteína** - Vermelho
- 🔵 **Carboidratos** - Azul
- 🟡 **Gorduras** - Amarelo
- 🔷 **Água** - Ciano

## 📝 Cálculos Implementados

### TMB (Taxa Metabólica Basal)
- **Homens**: (10 × peso) + (6.25 × altura) - (5 × idade) + 5
- **Mulheres**: (10 × peso) + (6.25 × altura) - (5 × idade) - 161

### TDEE (Gasto Calórico Total)
- TMB × Nível de Atividade (1.2 a 1.9)

### Metas Calóricas
- **Perder peso**: TDEE - 500 kcal
- **Manter peso**: TDEE
- **Ganhar músculos**: TDEE + 300 kcal

### Metas de Macros
- **Ganhar músculos**: 30% proteína, 45% carbos, 25% gorduras
- **Perder peso**: 40% proteína, 35% carbos, 25% gorduras
- **Manter peso**: 30% proteína, 40% carbos, 30% gorduras

### Meta de Água
- 35ml por kg de peso corporal

## 🚧 Próximas Melhorias

- [ ] Adicionar mais alimentos ao banco de dados
- [ ] Sistema de lembretes para refeições
- [ ] Exportação de dados em PDF
- [ ] Gráficos de progresso semanal
- [ ] Receitas sugeridas baseadas nos macros

## 📄 Licença

Este projeto é open source e está disponível para uso pessoal.

---

Desenvolvido com ❤️ para ajudar você a alcançar seus objetivos nutricionais!
