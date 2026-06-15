// Food Database
const FOOD_DATABASE = [
    {id: 1, name: 'Peito de Frango Grelhado', category: 'proteins', calories: 165, protein: 31, carbs: 0, fat: 3.6, emoji: '🍗', serving_size: 100},
    {id: 2, name: 'Ovo Cozido', category: 'proteins', calories: 155, protein: 13, carbs: 1.1, fat: 11, emoji: '🥚', serving_size: 100},
    {id: 3, name: 'Carne Bovina Magra', category: 'proteins', calories: 250, protein: 26, carbs: 0, fat: 15, emoji: '🥩', serving_size: 100},
    {id: 4, name: 'Peixe Branco', category: 'proteins', calories: 90, protein: 18, carbs: 0, fat: 1, emoji: '🐟', serving_size: 100},
    {id: 5, name: 'Atum em Conserva', category: 'proteins', calories: 116, protein: 26, carbs: 0, fat: 1, emoji: '🐟', serving_size: 100},
    {id: 6, name: 'Tofu', category: 'proteins', calories: 76, protein: 8, carbs: 1.9, fat: 4.8, emoji: '🧈', serving_size: 100},
    {id: 7, name: 'Iogurte Natural', category: 'proteins', calories: 59, protein: 10, carbs: 3.6, fat: 0.4, emoji: '🥛', serving_size: 100},
    {id: 8, name: 'Queijo Minas', category: 'proteins', calories: 320, protein: 25, carbs: 0, fat: 25, emoji: '🧀', serving_size: 100},
    {id: 9, name: 'Arroz Branco Cozido', category: 'carbs', calories: 130, protein: 2.7, carbs: 28, fat: 0.3, emoji: '🍚', serving_size: 100},
    {id: 10, name: 'Arroz Integral', category: 'carbs', calories: 111, protein: 2.6, carbs: 23, fat: 0.9, emoji: '🍚', serving_size: 100},
    {id: 11, name: 'Feijão Preto Cozido', category: 'carbs', calories: 132, protein: 8.7, carbs: 24, fat: 0.5, emoji: '🫘', serving_size: 100},
    {id: 12, name: 'Batata Cozida', category: 'carbs', calories: 87, protein: 1.9, carbs: 20, fat: 0.1, emoji: '🥔', serving_size: 100},
    {id: 13, name: 'Pão Francês', category: 'carbs', calories: 285, protein: 9, carbs: 50, fat: 3, emoji: '🥖', serving_size: 100},
    {id: 14, name: 'Pão Integral', category: 'carbs', calories: 250, protein: 13, carbs: 45, fat: 3, emoji: '🍞', serving_size: 100},
    {id: 15, name: 'Macarrão Cozido', category: 'carbs', calories: 131, protein: 5, carbs: 25, fat: 1.1, emoji: '🍝', serving_size: 100},
    {id: 16, name: 'Aveia em Flocos', category: 'carbs', calories: 389, protein: 16.9, carbs: 66, fat: 6.9, emoji: '🥣', serving_size: 100},
    {id: 17, name: 'Banana', category: 'fruits', calories: 89, protein: 1.1, carbs: 23, fat: 0.3, emoji: '🍌', serving_size: 100},
    {id: 18, name: 'Maçã', category: 'fruits', calories: 52, protein: 0.3, carbs: 14, fat: 0.2, emoji: '🍎', serving_size: 100},
    {id: 19, name: 'Alface', category: 'vegetables', calories: 15, protein: 1.4, carbs: 2.9, fat: 0.2, emoji: '🥬', serving_size: 100},
    {id: 20, name: 'Tomate', category: 'vegetables', calories: 18, protein: 0.9, carbs: 3.9, fat: 0.2, emoji: '🍅', serving_size: 100},
    {id: 21, name: 'Brócolis Cozido', category: 'vegetables', calories: 35, protein: 2.4, carbs: 7, fat: 0.4, emoji: '🥦', serving_size: 100},
    {id: 22, name: 'Cenoura', category: 'vegetables', calories: 41, protein: 0.9, carbs: 10, fat: 0.2, emoji: '🥕', serving_size: 100},
    {id: 23, name: 'Azeite de Oliva', category: 'fats', calories: 884, protein: 0, carbs: 0, fat: 100, emoji: '🫒', serving_size: 100},
    {id: 24, name: 'Abacate', category: 'fats', calories: 160, protein: 2, carbs: 8.5, fat: 15, emoji: '🥑', serving_size: 100},
    {id: 25, name: 'Amendoim', category: 'fats', calories: 567, protein: 25, carbs: 16, fat: 49, emoji: '🥜', serving_size: 100},
    {id: 26, name: 'Manteiga', category: 'fats', calories: 717, protein: 0.9, carbs: 0.1, fat: 81, emoji: '🧈', serving_size: 100},
    {id: 27, name: 'Leite Integral', category: 'beverages', calories: 61, protein: 3.2, carbs: 4.8, fat: 3.3, emoji: '🥛', serving_size: 100},
    {id: 28, name: 'Leite Desnatado', category: 'beverages', calories: 35, protein: 3.4, carbs: 5, fat: 0.1, emoji: '🥛', serving_size: 100},
    {id: 29, name: 'Suco de Laranja Natural', category: 'beverages', calories: 45, protein: 0.7, carbs: 10.4, fat: 0.2, emoji: '🍊', serving_size: 100},
    {id: 30, name: 'Café Preto', category: 'beverages', calories: 2, protein: 0.3, carbs: 0, fat: 0, emoji: '☕', serving_size: 100},
];

// State
let currentUser = null;
let currentDate = new Date();
let selectedFoods = {};
let currentMealType = 'breakfast';
let currentCategory = 'all';
let customFoods = [];
let waterReminderEnabled = false;
let waterReminderTime = '09:00';

// Initialize
function init() {
    loadUserData();
    loadCustomFoods();
    loadWaterReminderSettings();
    if (currentUser) {
        showScreen('dashboard');
        updateDashboard();
        setupWaterReminder();
    } else {
        showScreen('register');
    }
    renderFoodGrid();
}

// Local Storage Functions
function saveUserData() {
    localStorage.setItem('nutriela_user', JSON.stringify(currentUser));
}

function loadUserData() {
    const userData = localStorage.getItem('nutriela_user');
    if (userData) {
        currentUser = JSON.parse(userData);
    }
}

function saveMealData() {
    const mealData = localStorage.getItem('nutriela_meals') || '{}';
    const meals = JSON.parse(mealData);
    localStorage.setItem('nutriela_meals', JSON.stringify(meals));
}

function getMealData() {
    const mealData = localStorage.getItem('nutriela_meals') || '{}';
    return JSON.parse(mealData);
}

function saveWaterData() {
    const waterData = localStorage.getItem('nutriela_water') || '{}';
    localStorage.setItem('nutriela_water', waterData);
}

function getWaterData() {
    const waterData = localStorage.getItem('nutriela_water') || '{}';
    return JSON.parse(waterData);
}

// Custom Foods Functions
function saveCustomFoods() {
    localStorage.setItem('nutriela_custom_foods', JSON.stringify(customFoods));
}

function loadCustomFoods() {
    const saved = localStorage.getItem('nutriela_custom_foods');
    if (saved) {
        customFoods = JSON.parse(saved);
    }
}

function addCustomFood(food) {
    const newId = Math.max(...FOOD_DATABASE.map(f => f.id), ...customFoods.map(f => f.id), 0) + 1;
    const newFood = {
        id: newId,
        ...food,
        custom: true
    };
    customFoods.push(newFood);
    saveCustomFoods();
    return newFood;
}

function getAllFoods() {
    return [...FOOD_DATABASE, ...customFoods];
}

// Water Reminder Functions
function saveWaterReminderSettings() {
    localStorage.setItem('nutriela_water_reminder', JSON.stringify({
        enabled: waterReminderEnabled,
        time: waterReminderTime
    }));
}

function loadWaterReminderSettings() {
    const saved = localStorage.getItem('nutriela_water_reminder');
    if (saved) {
        const settings = JSON.parse(saved);
        waterReminderEnabled = settings.enabled || false;
        waterReminderTime = settings.time || '09:00';
    }
}

function requestNotificationPermission() {
    if ('Notification' in window) {
        Notification.requestPermission().then(permission => {
            if (permission === 'granted') {
                console.log('Permissão de notificação concedida');
            }
        });
    }
}

function setupWaterReminder() {
    if (!waterReminderEnabled) return;
    
    requestNotificationPermission();
    
    // Check every minute if it's time to remind
    setInterval(() => {
        const now = new Date();
        const currentTime = now.getHours().toString().padStart(2, '0') + ':' + 
                          now.getMinutes().toString().padStart(2, '0');
        
        if (currentTime === waterReminderTime && 'Notification' in window && 
            Notification.permission === 'granted') {
            const dateStr = currentDate.toISOString().split('T')[0];
            const waterData = getWaterData();
            const waterIntake = waterData[dateStr] || 0;
            const waterGoal = calculateWaterGoal(currentUser);
            
            if (waterIntake < waterGoal) {
                new Notification('💧 Lembrete de Água - Nutriela', {
                    body: `Você bebeu ${(waterIntake / 1000).toFixed(1)}L de ${waterGoal / 1000}L. Hora de beber mais água!`,
                    icon: 'icon-192.png',
                    badge: 'icon-192.png'
                });
            }
        }
    }, 60000); // Check every minute
}

function toggleWaterReminder(enabled, time) {
    waterReminderEnabled = enabled;
    waterReminderTime = time;
    saveWaterReminderSettings();
    
    if (enabled) {
        requestNotificationPermission();
    }
}

// Nutritional Calculations
function calculateBMR(user) {
    if (user.gender === 'male') {
        return (10 * user.weight) + (6.25 * user.height) - (5 * user.age) + 5;
    } else {
        return (10 * user.weight) + (6.25 * user.height) - (5 * user.age) - 161;
    }
}

function calculateTDEE(user) {
    return calculateBMR(user) * user.activity_level;
}

function calculateCalorieGoal(user) {
    const tdee = calculateTDEE(user);
    if (user.goal === 'lose_weight') return tdee - 500;
    if (user.goal === 'gain_muscle') return tdee + 300;
    return tdee;
}

function calculateBMI(user) {
    const heightM = user.height / 100;
    return user.weight / (heightM * heightM);
}

function calculateMacroGoals(user) {
    const calorieGoal = calculateCalorieGoal(user);
    let protein, carbs, fat;
    
    if (user.goal === 'gain_muscle') {
        protein = (calorieGoal * 0.30) / 4;
        carbs = (calorieGoal * 0.45) / 4;
        fat = (calorieGoal * 0.25) / 9;
    } else if (user.goal === 'lose_weight') {
        protein = (calorieGoal * 0.40) / 4;
        carbs = (calorieGoal * 0.35) / 4;
        fat = (calorieGoal * 0.25) / 9;
    } else {
        protein = (calorieGoal * 0.30) / 4;
        carbs = (calorieGoal * 0.40) / 4;
        fat = (calorieGoal * 0.30) / 9;
    }
    
    return { protein, carbs, fat };
}

function calculateWaterGoal(user) {
    return user.weight * 35;
}

function getBMIStatus(bmi) {
    if (bmi < 18.5) return 'Abaixo do peso';
    if (bmi < 25) return 'Normal';
    if (bmi < 30) return 'Sobrepeso';
    if (bmi < 35) return 'Obesidade I';
    if (bmi < 40) return 'Obesidade II';
    return 'Obesidade III';
}

// Screen Navigation
function showScreen(screenName) {
    document.querySelectorAll('.screen').forEach(screen => {
        screen.classList.remove('active');
    });
    document.getElementById(screenName + 'Screen').classList.add('active');
    
    if (screenName === 'dashboard') {
        updateDashboard();
    } else if (screenName === 'profile') {
        updateProfile();
    } else if (screenName === 'addMeal') {
        selectedFoods = {};
        updateSelectedFoods();
    } else if (screenName === 'addCustomFood') {
        renderCustomFoodsList();
    } else if (screenName === 'updateWeight') {
        // Pre-fill current weight
        document.getElementById('newWeight').value = currentUser.weight;
    } else if (screenName === 'settings') {
        // Pre-fill current goal and activity
        document.getElementById('editGoal').value = currentUser.goal;
        document.getElementById('editActivity').value = currentUser.activity_level;
        document.getElementById('waterReminderEnabled').checked = waterReminderEnabled;
        document.getElementById('waterReminderTime').value = waterReminderTime;
    }
}

// Registration
function handleRegister(event) {
    event.preventDefault();
    
    currentUser = {
        name: document.getElementById('regName').value,
        age: parseInt(document.getElementById('regAge').value),
        weight: parseFloat(document.getElementById('regWeight').value),
        height: parseFloat(document.getElementById('regHeight').value),
        gender: document.getElementById('regGender').value,
        goal: document.getElementById('regGoal').value,
        activity_level: parseFloat(document.getElementById('regActivity').value),
        created_at: new Date().toISOString()
    };
    
    saveUserData();
    showScreen('dashboard');
}

// Dashboard
function updateDashboard() {
    if (!currentUser) return;
    
    const dateStr = currentDate.toISOString().split('T')[0];
    document.getElementById('currentDate').textContent = formatDate(currentDate);
    
    // Update user info card
    document.getElementById('dashboardUserName').textContent = currentUser.name;
    document.getElementById('dashboardUserInfo').textContent = `${currentUser.age} anos • ${currentUser.gender === 'male' ? 'Masculino' : 'Feminino'}`;
    document.getElementById('dashboardWeight').textContent = currentUser.weight.toFixed(1);
    
    const bmi = calculateBMI(currentUser);
    document.getElementById('dashboardBMI').textContent = bmi.toFixed(1);
    
    const meals = getMealsForDate(dateStr);
    const waterIntake = getWaterForDate(dateStr);
    
    const totalCalories = meals.reduce((sum, meal) => {
        return sum + meal.items.reduce((s, item) => s + item.calories, 0);
    }, 0);
    
    const totalProtein = meals.reduce((sum, meal) => {
        return sum + meal.items.reduce((s, item) => s + item.protein, 0);
    }, 0);
    
    const totalCarbs = meals.reduce((sum, meal) => {
        return sum + meal.items.reduce((s, item) => s + item.carbs, 0);
    }, 0);
    
    const totalFat = meals.reduce((sum, meal) => {
        return sum + meal.items.reduce((s, item) => s + item.fat, 0);
    }, 0);
    
    const totalWater = waterIntake;
    
    const calorieGoal = calculateCalorieGoal(currentUser);
    const macroGoals = calculateMacroGoals(currentUser);
    const waterGoal = calculateWaterGoal(currentUser);
    
    document.getElementById('totalCalories').textContent = Math.round(totalCalories);
    document.getElementById('totalProtein').textContent = totalProtein.toFixed(1);
    document.getElementById('totalCarbs').textContent = totalCarbs.toFixed(1);
    document.getElementById('totalFat').textContent = totalFat.toFixed(1);
    document.getElementById('totalWater').textContent = (totalWater / 1000).toFixed(1);
    
    document.getElementById('calorieGoal').textContent = Math.round(calorieGoal);
    document.getElementById('proteinGoal').textContent = macroGoals.protein.toFixed(1);
    document.getElementById('carbsGoal').textContent = macroGoals.carbs.toFixed(1);
    document.getElementById('fatGoal').textContent = macroGoals.fat.toFixed(1);
    document.getElementById('waterGoal').textContent = (waterGoal / 1000).toFixed(1);
    
    document.getElementById('calorieProgress').style.width = Math.min((totalCalories / calorieGoal) * 100, 100) + '%';
    document.getElementById('proteinProgress').style.width = Math.min((totalProtein / macroGoals.protein) * 100, 100) + '%';
    document.getElementById('carbsProgress').style.width = Math.min((totalCarbs / macroGoals.carbs) * 100, 100) + '%';
    document.getElementById('fatProgress').style.width = Math.min((totalFat / macroGoals.fat) * 100, 100) + '%';
    document.getElementById('waterProgress').style.width = Math.min((totalWater / waterGoal) * 100, 100) + '%';
    
    renderMealsList(meals);
}

function renderMealsList(meals) {
    const container = document.getElementById('mealsList');
    
    if (meals.length === 0) {
        container.innerHTML = '<p style="text-align: center; color: #999; padding: 20px;">Nenhuma refeição registrada hoje</p>';
        return;
    }
    
    const mealNames = {
        'breakfast': '🌅 Café da Manhã',
        'lunch': '☀️ Almoço',
        'dinner': '🌙 Jantar',
        'snack': '🍪 Lanche'
    };
    
    container.innerHTML = meals.map(meal => {
        const mealCalories = meal.items.reduce((sum, item) => sum + item.calories, 0);
        const foodNames = meal.items.map(item => `${item.food_name} (${Math.round(item.grams)}g)`).join(', ');
        
        return `
            <div class="meal-item">
                <div>
                    <strong>${mealNames[meal.type]}</strong>
                    <div style="font-size: 12px; color: #666;">${foodNames}</div>
                </div>
                <div style="text-align: right;">
                    <div style="font-weight: bold; color: #667eea;">${Math.round(mealCalories)} kcal</div>
                    <div style="font-size: 11px; color: #999;">${meal.items.length} itens</div>
                </div>
            </div>
        `;
    }).join('');
}

function getMealsForDate(dateStr) {
    const mealData = getMealData();
    return mealData[dateStr] || [];
}

function getWaterForDate(dateStr) {
    const waterData = getWaterData();
    return waterData[dateStr] || 0;
}

function changeDate(days) {
    currentDate.setDate(currentDate.getDate() + days);
    updateDashboard();
}

function addWater() {
    const dateStr = currentDate.toISOString().split('T')[0];
    const waterData = getWaterData();
    waterData[dateStr] = (waterData[dateStr] || 0) + 250;
    localStorage.setItem('nutriela_water', JSON.stringify(waterData));
    updateDashboard();
}

// Add Meal
function renderFoodGrid() {
    const container = document.getElementById('foodGrid');
    const allFoods = getAllFoods();
    container.innerHTML = allFoods.map(food => `
        <div class="food-card ${food.custom ? 'custom-food' : ''}" data-food-id="${food.id}" data-category="${food.category}" data-name="${food.name.toLowerCase()}" onclick="toggleFood(${food.id})">
            <div class="food-emoji">${food.emoji || '🍽️'}</div>
            <div class="food-name">${food.name} ${food.custom ? '✨' : ''}</div>
            <div class="food-info">${food.calories} kcal/100g</div>
        </div>
    `).join('');
}

function setMealType(type, btn) {
    currentMealType = type;
    document.querySelectorAll('#addMealScreen .category-btn').forEach(b => b.classList.remove('active'));
    btn.classList.add('active');
}

function filterCategory(category, btn) {
    currentCategory = category;
    document.querySelectorAll('#categoryFilter .category-btn').forEach(b => b.classList.remove('active'));
    btn.classList.add('active');
    filterFoods();
}

function filterFoods() {
    const searchTerm = document.getElementById('searchInput').value.toLowerCase();
    const cards = document.querySelectorAll('.food-card');
    
    cards.forEach(card => {
        const category = card.dataset.category;
        const name = card.dataset.name;
        
        const matchesCategory = currentCategory === 'all' || category === currentCategory;
        const matchesSearch = name.includes(searchTerm);
        
        card.style.display = matchesCategory && matchesSearch ? 'block' : 'none';
    });
}

function toggleFood(foodId) {
    const card = document.querySelector(`[data-food-id="${foodId}"]`);
    
    if (selectedFoods[foodId]) {
        delete selectedFoods[foodId];
        card.classList.remove('selected');
    } else {
        const food = getAllFoods().find(f => f.id === foodId);
        selectedFoods[foodId] = {
            food_id: food.id,
            food_name: food.name,
            grams: food.serving_size,
            calories: food.calories * (food.serving_size / 100),
            protein: food.protein * (food.serving_size / 100),
            carbs: food.carbs * (food.serving_size / 100),
            fat: food.fat * (food.serving_size / 100)
        };
        card.classList.add('selected');
    }
    
    updateSelectedFoods();
}

function updateSelectedFoods() {
    const card = document.getElementById('selectedFoodsCard');
    const list = document.getElementById('selectedFoodsList');
    const totalEl = document.getElementById('totalCaloriesSelected');
    
    const foods = Object.values(selectedFoods);
    
    if (foods.length === 0) {
        card.classList.add('hidden');
        return;
    }
    
    card.classList.remove('hidden');
    list.innerHTML = foods.map(food => `
        <div class="meal-item">
            <div>
                <strong>${food.food_name}</strong>
                <input type="number" value="${food.grams}" 
                       class="input-grams"
                       onchange="updateGrams(${food.food_id}, this.value)">
            </div>
            <div>${food.calories.toFixed(0)} kcal</div>
        </div>
    `).join('');
    
    const total = foods.reduce((sum, f) => sum + f.calories, 0);
    totalEl.textContent = total.toFixed(0);
}

function updateGrams(foodId, grams) {
    const food = getAllFoods().find(f => f.id === foodId);
    const multiplier = grams / 100;
    
    selectedFoods[foodId].grams = parseFloat(grams);
    selectedFoods[foodId].calories = food.calories * multiplier;
    selectedFoods[foodId].protein = food.protein * multiplier;
    selectedFoods[foodId].carbs = food.carbs * multiplier;
    selectedFoods[foodId].fat = food.fat * multiplier;
    
    updateSelectedFoods();
}

function saveMeal() {
    const foods = Object.values(selectedFoods);
    if (foods.length === 0) {
        alert('Selecione pelo menos um alimento');
        return;
    }
    
    const dateStr = currentDate.toISOString().split('T')[0];
    const mealData = getMealData();
    
    if (!mealData[dateStr]) {
        mealData[dateStr] = [];
    }
    
    mealData[dateStr].push({
        type: currentMealType,
        items: foods,
        timestamp: new Date().toISOString()
    });
    
    localStorage.setItem('nutriela_meals', JSON.stringify(mealData));
    
    selectedFoods = {};
    updateSelectedFoods();
    showScreen('dashboard');
}

// Profile
function updateProfile() {
    if (!currentUser) return;
    
    document.getElementById('profileName').textContent = currentUser.name;
    document.getElementById('profileInfo').textContent = `${currentUser.age} anos • ${currentUser.gender === 'male' ? 'Masculino' : 'Feminino'}`;
    
    document.getElementById('profileWeight').textContent = currentUser.weight;
    document.getElementById('profileHeight').textContent = currentUser.height;
    
    const bmi = calculateBMI(currentUser);
    document.getElementById('profileBMI').textContent = bmi.toFixed(1);
    
    const bmiStatus = getBMIStatus(bmi);
    const bmiEl = document.getElementById('bmiStatus');
    bmiEl.textContent = bmiStatus;
    bmiEl.style.padding = '4px 8px';
    bmiEl.style.borderRadius = '10px';
    bmiEl.style.display = 'inline-block';
    bmiEl.style.color = 'white';
    bmiEl.style.background = bmiStatus === 'Normal' ? '#48bb78' : bmiStatus === 'Abaixo do peso' || bmiStatus === 'Sobrepeso' ? '#f6ad55' : '#f56565';
    
    const calorieGoal = calculateCalorieGoal(currentUser);
    const macroGoals = calculateMacroGoals(currentUser);
    const waterGoal = calculateWaterGoal(currentUser);
    
    document.getElementById('profileCalorieGoal').textContent = Math.round(calorieGoal);
    document.getElementById('profileProteinGoal').textContent = macroGoals.protein.toFixed(1);
    document.getElementById('profileCarbsGoal').textContent = macroGoals.carbs.toFixed(1);
    document.getElementById('profileFatGoal').textContent = macroGoals.fat.toFixed(1);
    document.getElementById('profileWaterGoal').textContent = (waterGoal / 1000).toFixed(1);
    
    document.getElementById('profileBMR').textContent = Math.round(calculateBMR(currentUser)) + ' kcal';
    document.getElementById('profileTDEE').textContent = Math.round(calculateTDEE(currentUser)) + ' kcal';
    
    const goalNames = {
        'lose_weight': 'Perder peso',
        'maintain': 'Manter peso',
        'gain_muscle': 'Ganhar músculos'
    };
    document.getElementById('profileGoal').textContent = goalNames[currentUser.goal];
    
    const activityNames = {
        1.2: 'Sedentário',
        1.375: 'Levemente ativo',
        1.55: 'Moderadamente ativo',
        1.725: 'Muito ativo',
        1.9: 'Extremamente ativo'
    };
    document.getElementById('profileActivity').textContent = activityNames[currentUser.activity_level];
}

// Reset
function resetData() {
    if (confirm('Tem certeza que deseja resetar todos os dados?')) {
        localStorage.removeItem('nutriela_user');
        localStorage.removeItem('nutriela_meals');
        localStorage.removeItem('nutriela_water');
        currentUser = null;
        showScreen('register');
    }
}

// Change Goal
function handleChangeGoal(event) {
    event.preventDefault();
    
    currentUser.goal = document.getElementById('editGoal').value;
    currentUser.activity_level = parseFloat(document.getElementById('editActivity').value);
    saveUserData();
    
    updateDashboard();
    updateProfile();
    showScreen('dashboard');
}

// Update Weight
function handleUpdateWeight(event) {
    event.preventDefault();
    
    currentUser.weight = parseFloat(document.getElementById('newWeight').value);
    saveUserData();
    
    updateDashboard();
    updateProfile();
    showScreen('dashboard');
    
    alert('Peso atualizado com sucesso!');
}

// Add Custom Food
function handleAddCustomFood(event) {
    event.preventDefault();
    
    const newFood = {
        name: document.getElementById('customFoodName').value,
        category: document.getElementById('customFoodCategory').value,
        calories: parseFloat(document.getElementById('customFoodCalories').value),
        protein: parseFloat(document.getElementById('customFoodProtein').value),
        carbs: parseFloat(document.getElementById('customFoodCarbs').value),
        fat: parseFloat(document.getElementById('customFoodFat').value),
        emoji: document.getElementById('customFoodEmoji').value || '🍽️',
        serving_size: parseFloat(document.getElementById('customFoodServingSize').value) || 100
    };
    
    addCustomFood(newFood);
    renderFoodGrid();
    
    // Clear form
    document.getElementById('customFoodName').value = '';
    document.getElementById('customFoodCalories').value = '';
    document.getElementById('customFoodProtein').value = '';
    document.getElementById('customFoodCarbs').value = '';
    document.getElementById('customFoodFat').value = '';
    document.getElementById('customFoodEmoji').value = '';
    document.getElementById('customFoodServingSize').value = '100';
    
    alert('Alimento adicionado com sucesso!');
    showScreen('addMeal');
}

// Delete Custom Food
function deleteCustomFood(foodId) {
    if (confirm('Tem certeza que deseja excluir este alimento?')) {
        customFoods = customFoods.filter(f => f.id !== foodId);
        saveCustomFoods();
        renderFoodGrid();
        renderCustomFoodsList();
    }
}

function renderCustomFoodsList() {
    const container = document.getElementById('customFoodsList');
    if (!container) return;
    
    if (customFoods.length === 0) {
        container.innerHTML = '<p style="text-align: center; color: #999; padding: 20px;">Nenhum alimento personalizado cadastrado</p>';
        return;
    }
    
    container.innerHTML = customFoods.map(food => `
        <div class="meal-item">
            <div>
                <strong>${food.emoji} ${food.name}</strong>
                <div style="font-size: 12px; color: #666;">${food.calories} kcal/100g</div>
            </div>
            <button onclick="deleteCustomFood(${food.id})" class="btn btn-danger" style="padding: 5px 10px; font-size: 12px; width: auto;">🗑️</button>
        </div>
    `).join('');
}

// Water Reminder Settings
function handleWaterReminderSettings(event) {
    event.preventDefault();
    
    const enabled = document.getElementById('waterReminderEnabled').checked;
    const time = document.getElementById('waterReminderTime').value;
    
    toggleWaterReminder(enabled, time);
    
    if (enabled) {
        alert('Lembrete de água ativado! Você receberá notificações diárias às ' + time);
    } else {
        alert('Lembrete de água desativado');
    }
    
    showScreen('dashboard');
}

// Utility Functions
function formatDate(date) {
    const day = date.getDate().toString().padStart(2, '0');
    const month = (date.getMonth() + 1).toString().padStart(2, '0');
    const year = date.getFullYear();
    return `${day}/${month}/${year}`;
}

// Initialize on load
document.addEventListener('DOMContentLoaded', init);
