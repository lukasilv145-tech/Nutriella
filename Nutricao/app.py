from flask import Flask, render_template, request, redirect, url_for, flash, jsonify
from flask_sqlalchemy import SQLAlchemy
from datetime import datetime, date
import json

app = Flask(__name__)
app.config['SECRET_KEY'] = 'nutriela-secret-key-2024'
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///nutriela.db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)

# Custom Jinja filter for JSON parsing
@app.template_filter('from_json')
def from_json_filter(s):
    try:
        return json.loads(s)
    except:
        return []

# Models
class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=False)
    age = db.Column(db.Integer, nullable=False)
    weight = db.Column(db.Float, nullable=False)
    height = db.Column(db.Float, nullable=False)
    gender = db.Column(db.String(10), nullable=False)
    goal = db.Column(db.String(20), nullable=False)
    activity_level = db.Column(db.Float, nullable=False)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)

    def calculate_bmr(self):
        if self.gender == 'male':
            return (10 * self.weight) + (6.25 * self.height) - (5 * self.age) + 5
        else:
            return (10 * self.weight) + (6.25 * self.height) - (5 * self.age) - 161

    def calculate_tdee(self):
        return self.calculate_bmr() * self.activity_level

    def calculate_calorie_goal(self):
        tdee = self.calculate_tdee()
        if self.goal == 'lose_weight':
            return tdee - 500
        elif self.goal == 'gain_muscle':
            return tdee + 300
        else:
            return tdee

    def calculate_bmi(self):
        height_m = self.height / 100
        return self.weight / (height_m * height_m)

    def calculate_macro_goals(self):
        calorie_goal = self.calculate_calorie_goal()
        if self.goal == 'gain_muscle':
            protein = (calorie_goal * 0.30) / 4
            carbs = (calorie_goal * 0.45) / 4
            fat = (calorie_goal * 0.25) / 9
        elif self.goal == 'lose_weight':
            protein = (calorie_goal * 0.40) / 4
            carbs = (calorie_goal * 0.35) / 4
            fat = (calorie_goal * 0.25) / 9
        else:
            protein = (calorie_goal * 0.30) / 4
            carbs = (calorie_goal * 0.40) / 4
            fat = (calorie_goal * 0.30) / 9
        return {'protein': protein, 'carbs': carbs, 'fat': fat}

    def calculate_water_goal(self):
        return self.weight * 35

class Food(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=False)
    category = db.Column(db.String(50), nullable=False)
    calories = db.Column(db.Float, nullable=False)
    protein = db.Column(db.Float, nullable=False)
    carbs = db.Column(db.Float, nullable=False)
    fat = db.Column(db.Float, nullable=False)
    emoji = db.Column(db.String(10))
    serving_size = db.Column(db.Float, default=100)

class Meal(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)
    type = db.Column(db.String(20), nullable=False)
    date = db.Column(db.Date, nullable=False)
    items = db.Column(db.Text, nullable=False)  # JSON string

    user = db.relationship('User', backref=db.backref('meals', lazy=True))

class WaterIntake(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)
    date = db.Column(db.Date, nullable=False)
    amount = db.Column(db.Float, nullable=False)

    user = db.relationship('User', backref=db.backref('water_intakes', lazy=True))

# Food Database
FOOD_DATABASE = [
    {'id': 1, 'name': 'Peito de Frango Grelhado', 'category': 'proteins', 'calories': 165, 'protein': 31, 'carbs': 0, 'fat': 3.6, 'emoji': '🍗', 'serving_size': 100},
    {'id': 2, 'name': 'Ovo Cozido', 'category': 'proteins', 'calories': 155, 'protein': 13, 'carbs': 1.1, 'fat': 11, 'emoji': '🥚', 'serving_size': 100},
    {'id': 3, 'name': 'Carne Bovina Magra', 'category': 'proteins', 'calories': 250, 'protein': 26, 'carbs': 0, 'fat': 15, 'emoji': '🥩', 'serving_size': 100},
    {'id': 4, 'name': 'Peixe Branco', 'category': 'proteins', 'calories': 90, 'protein': 18, 'carbs': 0, 'fat': 1, 'emoji': '🐟', 'serving_size': 100},
    {'id': 5, 'name': 'Atum em Conserva', 'category': 'proteins', 'calories': 116, 'protein': 26, 'carbs': 0, 'fat': 1, 'emoji': '🐟', 'serving_size': 100},
    {'id': 6, 'name': 'Tofu', 'category': 'proteins', 'calories': 76, 'protein': 8, 'carbs': 1.9, 'fat': 4.8, 'emoji': '🧈', 'serving_size': 100},
    {'id': 7, 'name': 'Iogurte Natural', 'category': 'proteins', 'calories': 59, 'protein': 10, 'carbs': 3.6, 'fat': 0.4, 'emoji': '🥛', 'serving_size': 100},
    {'id': 8, 'name': 'Queijo Minas', 'category': 'proteins', 'calories': 320, 'protein': 25, 'carbs': 0, 'fat': 25, 'emoji': '🧀', 'serving_size': 100},
    {'id': 9, 'name': 'Arroz Branco Cozido', 'category': 'carbs', 'calories': 130, 'protein': 2.7, 'carbs': 28, 'fat': 0.3, 'emoji': '🍚', 'serving_size': 100},
    {'id': 10, 'name': 'Arroz Integral', 'category': 'carbs', 'calories': 111, 'protein': 2.6, 'carbs': 23, 'fat': 0.9, 'emoji': '🍚', 'serving_size': 100},
    {'id': 11, 'name': 'Feijão Preto Cozido', 'category': 'carbs', 'calories': 132, 'protein': 8.7, 'carbs': 24, 'fat': 0.5, 'emoji': '🫘', 'serving_size': 100},
    {'id': 12, 'name': 'Batata Cozida', 'category': 'carbs', 'calories': 87, 'protein': 1.9, 'carbs': 20, 'fat': 0.1, 'emoji': '🥔', 'serving_size': 100},
    {'id': 13, 'name': 'Pão Francês', 'category': 'carbs', 'calories': 285, 'protein': 9, 'carbs': 50, 'fat': 3, 'emoji': '🥖', 'serving_size': 100},
    {'id': 14, 'name': 'Pão Integral', 'category': 'carbs', 'calories': 250, 'protein': 13, 'carbs': 45, 'fat': 3, 'emoji': '🍞', 'serving_size': 100},
    {'id': 15, 'name': 'Macarrão Cozido', 'category': 'carbs', 'calories': 131, 'protein': 5, 'carbs': 25, 'fat': 1.1, 'emoji': '🍝', 'serving_size': 100},
    {'id': 16, 'name': 'Aveia em Flocos', 'category': 'carbs', 'calories': 389, 'protein': 16.9, 'carbs': 66, 'fat': 6.9, 'emoji': '🥣', 'serving_size': 100},
    {'id': 17, 'name': 'Banana', 'category': 'fruits', 'calories': 89, 'protein': 1.1, 'carbs': 23, 'fat': 0.3, 'emoji': '🍌', 'serving_size': 100},
    {'id': 18, 'name': 'Maçã', 'category': 'fruits', 'calories': 52, 'protein': 0.3, 'carbs': 14, 'fat': 0.2, 'emoji': '🍎', 'serving_size': 100},
    {'id': 19, 'name': 'Alface', 'category': 'vegetables', 'calories': 15, 'protein': 1.4, 'carbs': 2.9, 'fat': 0.2, 'emoji': '🥬', 'serving_size': 100},
    {'id': 20, 'name': 'Tomate', 'category': 'vegetables', 'calories': 18, 'protein': 0.9, 'carbs': 3.9, 'fat': 0.2, 'emoji': '🍅', 'serving_size': 100},
    {'id': 21, 'name': 'Brócolis Cozido', 'category': 'vegetables', 'calories': 35, 'protein': 2.4, 'carbs': 7, 'fat': 0.4, 'emoji': '🥦', 'serving_size': 100},
    {'id': 22, 'name': 'Cenoura', 'category': 'vegetables', 'calories': 41, 'protein': 0.9, 'carbs': 10, 'fat': 0.2, 'emoji': '🥕', 'serving_size': 100},
    {'id': 23, 'name': 'Azeite de Oliva', 'category': 'fats', 'calories': 884, 'protein': 0, 'carbs': 0, 'fat': 100, 'emoji': '🫒', 'serving_size': 100},
    {'id': 24, 'name': 'Abacate', 'category': 'fats', 'calories': 160, 'protein': 2, 'carbs': 8.5, 'fat': 15, 'emoji': '🥑', 'serving_size': 100},
    {'id': 25, 'name': 'Amendoim', 'category': 'fats', 'calories': 567, 'protein': 25, 'carbs': 16, 'fat': 49, 'emoji': '🥜', 'serving_size': 100},
    {'id': 26, 'name': 'Manteiga', 'category': 'fats', 'calories': 717, 'protein': 0.9, 'carbs': 0.1, 'fat': 81, 'emoji': '🧈', 'serving_size': 100},
    {'id': 27, 'name': 'Leite Integral', 'category': 'beverages', 'calories': 61, 'protein': 3.2, 'carbs': 4.8, 'fat': 3.3, 'emoji': '🥛', 'serving_size': 100},
    {'id': 28, 'name': 'Leite Desnatado', 'category': 'beverages', 'calories': 35, 'protein': 3.4, 'carbs': 5, 'fat': 0.1, 'emoji': '🥛', 'serving_size': 100},
    {'id': 29, 'name': 'Suco de Laranja Natural', 'category': 'beverages', 'calories': 45, 'protein': 0.7, 'carbs': 10.4, 'fat': 0.2, 'emoji': '🍊', 'serving_size': 100},
    {'id': 30, 'name': 'Café Preto', 'category': 'beverages', 'calories': 2, 'protein': 0.3, 'carbs': 0, 'fat': 0, 'emoji': '☕', 'serving_size': 100},
]

# Routes
@app.route('/')
def index():
    user = User.query.first()
    if user:
        return redirect(url_for('dashboard'))
    return redirect(url_for('register'))

@app.route('/register', methods=['GET', 'POST'])
def register():
    if request.method == 'POST':
        user = User(
            name=request.form['name'],
            age=int(request.form['age']),
            weight=float(request.form['weight']),
            height=float(request.form['height']),
            gender=request.form['gender'],
            goal=request.form['goal'],
            activity_level=float(request.form['activity_level'])
        )
        db.session.add(user)
        db.session.commit()
        return redirect(url_for('dashboard'))
    return render_template('register.html')

@app.route('/dashboard')
def dashboard():
    user = User.query.first()
    if not user:
        return redirect(url_for('register'))
    
    selected_date = request.args.get('date', date.today().isoformat())
    selected_date = datetime.strptime(selected_date, '%Y-%m-%d').date()
    
    meals = Meal.query.filter_by(user_id=user.id, date=selected_date).all()
    water_intakes = WaterIntake.query.filter_by(user_id=user.id, date=selected_date).all()
    
    total_calories = sum(sum(item['calories'] for item in json.loads(meal.items)) for meal in meals)
    total_protein = sum(sum(item['protein'] for item in json.loads(meal.items)) for meal in meals)
    total_carbs = sum(sum(item['carbs'] for item in json.loads(meal.items)) for meal in meals)
    total_fat = sum(sum(item['fat'] for item in json.loads(meal.items)) for meal in meals)
    total_water = sum(w.amount for w in water_intakes)
    
    calorie_goal = user.calculate_calorie_goal()
    macro_goals = user.calculate_macro_goals()
    water_goal = user.calculate_water_goal()
    
    return render_template('dashboard.html', 
                         user=user, 
                         selected_date=selected_date,
                         meals=meals,
                         total_calories=total_calories,
                         total_protein=total_protein,
                         total_carbs=total_carbs,
                         total_fat=total_fat,
                         total_water=total_water,
                         calorie_goal=calorie_goal,
                         macro_goals=macro_goals,
                         water_goal=water_goal)

@app.route('/add_meal', methods=['GET', 'POST'])
def add_meal():
    user = User.query.first()
    if not user:
        return redirect(url_for('register'))
    
    if request.method == 'POST':
        selected_date = request.form.get('date', date.today().isoformat())
        meal_type = request.form['meal_type']
        items = json.loads(request.form['items'])
        
        meal = Meal(
            user_id=user.id,
            type=meal_type,
            date=datetime.strptime(selected_date, '%Y-%m-%d').date(),
            items=json.dumps(items)
        )
        db.session.add(meal)
        db.session.commit()
        return redirect(url_for('dashboard', date=selected_date))
    
    selected_date = request.args.get('date', date.today().isoformat())
    return render_template('add_meal.html', 
                         selected_date=selected_date,
                         food_database=FOOD_DATABASE)

@app.route('/add_water', methods=['POST'])
def add_water():
    user = User.query.first()
    if not user:
        return redirect(url_for('register'))
    
    selected_date = request.form.get('date', date.today().isoformat())
    water_intake = WaterIntake(
        user_id=user.id,
        date=datetime.strptime(selected_date, '%Y-%m-%d').date(),
        amount=250
    )
    db.session.add(water_intake)
    db.session.commit()
    return redirect(url_for('dashboard', date=selected_date))

@app.route('/profile')
def profile():
    user = User.query.first()
    if not user:
        return redirect(url_for('register'))
    
    bmi = user.calculate_bmi()
    bmi_status = get_bmi_status(bmi)
    tdee = user.calculate_tdee()
    calorie_goal = user.calculate_calorie_goal()
    macro_goals = user.calculate_macro_goals()
    water_goal = user.calculate_water_goal()
    
    return render_template('profile.html',
                         user=user,
                         bmi=bmi,
                         bmi_status=bmi_status,
                         tdee=tdee,
                         calorie_goal=calorie_goal,
                         macro_goals=macro_goals,
                         water_goal=water_goal)

@app.route('/reset')
def reset():
    db.drop_all()
    db.create_all()
    return redirect(url_for('register'))

def get_bmi_status(bmi):
    if bmi < 18.5:
        return 'Abaixo do peso'
    elif bmi < 25:
        return 'Normal'
    elif bmi < 30:
        return 'Sobrepeso'
    elif bmi < 35:
        return 'Obesidade I'
    elif bmi < 40:
        return 'Obesidade II'
    else:
        return 'Obesidade III'

if __name__ == '__main__':
    with app.app_context():
        db.create_all()
    app.run(debug=True, host='0.0.0.0', port=5000)
