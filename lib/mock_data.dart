
// Mock data for the entire application to ensure consistency
import 'package:flutter/material.dart';

final List<Map<String, dynamic>> onboardingData = [
  {
    "id": "fresh_produce",
    "title": "Fresh Fruits & Vegetables",
    "subtitle": "Farm fresh organic produce delivered to your doorstep.",
    "heroImage": "https://images.unsplash.com/photo-1610832958506-aa56368176cf?auto=format&fit=crop&w=800&q=80",
    "color": const Color(0xFFE8F5E9),
    "accent": Colors.green,
    "stores": [
      {
        "name": "GreenFarm Market",
        "rating": 4.8,
        "time": "15-20 min",
        "distance": "1.2 km",
        "image": "https://images.unsplash.com/photo-1488459716781-31db52582fe9?auto=format&fit=crop&w=400&q=80",
        "products": [
          {"name": "Organic Banana", "price": "₹60/dz", "rating": 4.5, "image": "https://images.unsplash.com/photo-1571771896612-424bafbef5b9?auto=format&fit=crop&w=400&q=80", "desc": "Sweet and organic robusta bananas."},
          {"name": "Red Apple", "price": "₹180/kg", "rating": 4.7, "image": "https://images.unsplash.com/photo-1570913149827-d2ac84ab3f9a?auto=format&fit=crop&w=400&q=80", "desc": "Crispy and sweet Shimla apples."},
          {"name": "Avocado", "price": "₹90/pc", "rating": 4.3, "image": "https://images.unsplash.com/photo-1523049673856-38866de6c0be?auto=format&fit=crop&w=400&q=80", "desc": "Butter fruit rich in healthy fats."},
          {"name": "Spinach", "price": "₹40/bundle", "rating": 4.6, "image": "https://images.unsplash.com/photo-1576045057995-568f588f82fb?auto=format&fit=crop&w=400&q=80", "desc": "Fresh leafy green spinach."},
          {"name": "Tomato", "price": "₹30/kg", "rating": 4.4, "image": "https://images.unsplash.com/photo-1592924357228-91a4daadcfea?auto=format&fit=crop&w=400&q=80", "desc": "Juicy red tomatoes for curries."},
        ]
      },
      {
        "name": "Fresh Valley",
        "rating": 4.5,
        "time": "25-30 min",
        "distance": "2.5 km",
        "image": "https://images.unsplash.com/photo-1542838132-92c53300491e?auto=format&fit=crop&w=400&q=80",
        "products": [
          {"name": "Carrot", "price": "₹50/kg", "rating": 4.2, "image": "https://images.unsplash.com/photo-1598170845058-32b9d6a5da37?auto=format&fit=crop&w=400&q=80", "desc": "Crunchy orange carrots."},
          {"name": "Broccoli", "price": "₹120/kg", "rating": 4.5, "image": "https://images.unsplash.com/photo-1459411621453-7b03977f9bfc?auto=format&fit=crop&w=400&q=80", "desc": "Fresh green broccoli florets."},
          {"name": "Potato", "price": "₹35/kg", "rating": 4.3, "image": "https://images.unsplash.com/photo-1518977676601-b53f82aba655?auto=format&fit=crop&w=400&q=80", "desc": "Starchy potatoes for fries."},
          {"name": "Onion", "price": "₹40/kg", "rating": 4.1, "image": "https://images.unsplash.com/photo-1508747703725-719777637510?auto=format&fit=crop&w=400&q=80", "desc": "Essential kitchen onions."},
           {"name": "Capsicum", "price": "₹60/kg", "rating": 4.4, "image": "https://images.unsplash.com/photo-1563565375-f3fdf5dbc240?auto=format&fit=crop&w=400&q=80", "desc": "Green bell peppers."},
        ]
      }
    ]
  },
  {
    "id": "dairy_essentials",
    "title": "Dairy & Essentials",
    "subtitle": "Milk, cheese, butter and daily staples.",
    "heroImage": "https://images.unsplash.com/photo-1628088062854-d1870b4553da?auto=format&fit=crop&w=800&q=80",
     "color": const Color(0xFFE3F2FD),
    "accent": Colors.blue,
    "stores": [
      {
        "name": "Daily Dairy",
        "rating": 4.7,
        "time": "10-15 min",
        "distance": "0.8 km",
        "image": "https://images.unsplash.com/photo-1550583724-b2692b85b150?auto=format&fit=crop&w=400&q=80",
        "products": [
          {"name": "Full Cream Milk", "price": "₹70/L", "rating": 4.6, "image": "https://images.unsplash.com/photo-1563636619-e9143da7973b?auto=format&fit=crop&w=400&q=80", "desc": "Fresh pasteurized full cream milk."},
          {"name": "Butter", "price": "₹55/100g", "rating": 4.5, "image": "https://images.unsplash.com/photo-1589985270826-4b7bb135bc9d?auto=format&fit=crop&w=400&q=80", "desc": "Salted butter for toast."},
          {"name": "Eggs (12 pack)", "price": "₹90", "rating": 4.7, "image": "https://images.unsplash.com/photo-1506976785307-8732e854ad03?auto=format&fit=crop&w=400&q=80", "desc": "Farm fresh white eggs."},
          {"name": "Cheese Block", "price": "₹150/200g", "rating": 4.4, "image": "https://images.unsplash.com/photo-1618160702438-9b02ab6515c9?auto=format&fit=crop&w=400&q=80", "desc": "Processed cheddar cheese block."},
          {"name": "Yogurt", "price": "₹40/cup", "rating": 4.3, "image": "https://images.unsplash.com/photo-1563379926898-05f4575a45d8?auto=format&fit=crop&w=400&q=80", "desc": "Probiotic plain yogurt."},
        ]
      },
       {
        "name": "Essentials Mart",
        "rating": 4.5,
        "time": "20-25 min",
        "distance": "1.5 km",
        "image": "https://images.unsplash.com/photo-1542838132-92c53300491e?auto=format&fit=crop&w=400&q=80",
        "products": [
          {"name": "Paneer", "price": "₹120/200g", "rating": 4.5, "image": "https://images.unsplash.com/photo-1631452180519-c014fe946bc7?auto=format&fit=crop&w=400&q=80", "desc": "Soft fresh cottage cheese."},
          {"name": "Bread", "price": "₹45/loaf", "rating": 4.6, "image": "https://images.unsplash.com/photo-1598373182133-52452f7691ef?auto=format&fit=crop&w=400&q=80", "desc": "Whole wheat sandwich bread."},
          {"name": "Rice", "price": "₹80/kg", "rating": 4.4, "image": "https://images.unsplash.com/photo-1586201375761-83865001e31c?auto=format&fit=crop&w=400&q=80", "desc": "Basmati rice purely aged."},
          {"name": "Sugar", "price": "₹45/kg", "rating": 4.2, "image": "https://images.unsplash.com/photo-1612144706859-009c9826353d?auto=format&fit=crop&w=400&q=80", "desc": "Refined white sugar."},
          {"name": "Salt", "price": "₹20/kg", "rating": 4.8, "image": "https://images.unsplash.com/photo-1518110925495-5c3b9b46294a?auto=format&fit=crop&w=400&q=80", "desc": "Iodized table salt."},
        ]
      }
    ]
  },
  {
    "id": "beverages_snacks",
    "title": "Beverages & Snacks",
    "subtitle": "Cool drinks, chips and munchies.",
    "heroImage": "https://images.unsplash.com/photo-1621939514649-28b12e81658b?auto=format&fit=crop&w=800&q=80",
     "color": const Color(0xFFFFF3E0),
    "accent": Colors.orange,
    "stores": [
      {
        "name": "Snack Corner",
        "rating": 4.6,
        "time": "15 min",
        "distance": "1.0 km",
        "image": "https://images.unsplash.com/photo-1599490659213-e2b9527bd087?auto=format&fit=crop&w=400&q=80",
        "products": [
          {"name": "Orange Juice", "price": "₹120", "rating": 4.5, "image": "https://images.unsplash.com/photo-1613478223719-2ab802602423?auto=format&fit=crop&w=400&q=80", "desc": "Fresh squeezed orange juice."},
          {"name": "Cola", "price": "₹40", "rating": 4.2, "image": "https://images.unsplash.com/photo-1622483767028-3f66f32aef97?auto=format&fit=crop&w=400&q=80", "desc": "Chilled carbonated soft drink."},
          {"name": "Potato Chips", "price": "₹30", "rating": 4.6, "image": "https://images.unsplash.com/photo-1566478989066-3d4ea387612f?auto=format&fit=crop&w=400&q=80", "desc": "Salted potato crisps."},
          {"name": "Biscuits", "price": "₹20", "rating": 4.4, "image": "https://images.unsplash.com/photo-1558961363-fa8fdf82db35?auto=format&fit=crop&w=400&q=80", "desc": "Crunchy tea time biscuits."},
           {"name": "Nachos", "price": "₹60", "rating": 4.3, "image": "https://images.unsplash.com/photo-1513456852971-30c0b8199d4d?auto=format&fit=crop&w=400&q=80", "desc": "Cheese flavored corn chips."},
        ]
      },
       {
        "name": "Cool Drinks Store",
        "rating": 4.8,
        "time": "10 min",
        "distance": "0.5 km",
        "image": "https://images.unsplash.com/photo-1581006852262-e4307cf6283a?auto=format&fit=crop&w=400&q=80",
        "products": [
          {"name": "Green Tea", "price": "₹250/box", "rating": 4.4, "image": "https://images.unsplash.com/photo-1627435601361-ec2548cb927e?auto=format&fit=crop&w=400&q=80", "desc": "Detox herbal green tea."},
          {"name": "Energy Drink", "price": "₹110", "rating": 4.1, "image": "https://images.unsplash.com/photo-1622543925917-060461214533?auto=format&fit=crop&w=400&q=80", "desc": "Caffeinated energy booster."},
          {"name": "Chocolate Cookies", "price": "₹60", "rating": 4.7, "image": "https://images.unsplash.com/photo-1499636138143-bd649025ebeb?auto=format&fit=crop&w=400&q=80", "desc": "Choco chip cookies."},
          {"name": "Lemonade", "price": "₹40", "rating": 4.5, "image": "https://images.unsplash.com/photo-1513558161293-cdaf765ed2fd?auto=format&fit=crop&w=400&q=80", "desc": "Fresh mint lemonade."},
          {"name": "Popcorn", "price": "₹50", "rating": 4.3, "image": "https://images.unsplash.com/photo-1578849278619-e73505e9610f?auto=format&fit=crop&w=400&q=80", "desc": "Butter salted movie popcorn."},
        ]
      }
    ]
  },
  {
    "id": "fast_food",
    "title": "Fast Food & Bakery",
    "subtitle": "Burgers, pizzas and fresh bakery items.",
    "heroImage": "https://images.unsplash.com/photo-1561758033-d8f19662cb23?auto=format&fit=crop&w=800&q=80",
     "color": const Color(0xFFFBE9E7),
    "accent": Colors.deepOrange,
    "stores": [
      {
        "name": "Burger Town",
        "rating": 4.5,
        "time": "30-40 min",
        "distance": "3.2 km",
        "image": "https://images.unsplash.com/photo-1550547660-d9450f859349?auto=format&fit=crop&w=400&q=80",
        "products": [
          {"name": "Classic Burger", "price": "₹150", "rating": 4.6, "image": "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?auto=format&fit=crop&w=400&q=80", "desc": "Juicy beef patty burger."},
          {"name": "Cheese Pizza", "price": "₹350", "rating": 4.7, "image": "https://images.unsplash.com/photo-1513104890138-7c749659a591?auto=format&fit=crop&w=400&q=80", "desc": "Mozzarella cheese pizza."},
          {"name": "French Fries", "price": "₹90", "rating": 4.5, "image": "https://images.unsplash.com/photo-1573080496987-a202d6b2c6d7?auto=format&fit=crop&w=400&q=80", "desc": "Crispy salted fries."},
           {"name": "Hot Dog", "price": "₹120", "rating": 4.2, "image": "https://images.unsplash.com/photo-1612392062631-9bdd7772708d?auto=format&fit=crop&w=400&q=80", "desc": "Classic american hot dog."},
        ]
      },
      {
         "name": "Bakery Bliss",
        "rating": 4.8,
        "time": "20-25 min",
        "distance": "1.8 km",
        "image": "https://images.unsplash.com/photo-1509440159596-0249088772ff?auto=format&fit=crop&w=400&q=80",
        "products": [
           {"name": "Chocolate Donut", "price": "₹80", "rating": 4.5, "image": "https://images.unsplash.com/photo-1551024601-564d6d6744f1?auto=format&fit=crop&w=400&q=80", "desc": "Glazed chocolate donut."},
           {"name": "Croissant", "price": "₹90", "rating": 4.4, "image": "https://images.unsplash.com/photo-1555507036-ab1f4038808a?auto=format&fit=crop&w=400&q=80", "desc": "Butter french croissant."},
           {"name": "Sandwich", "price": "₹100", "rating": 4.3, "image": "https://images.unsplash.com/photo-1528735602780-2552fd46c7af?auto=format&fit=crop&w=400&q=80", "desc": "Grilled vegetable sandwich."},
           {"name": "Garlic Bread", "price": "₹110", "rating": 4.6, "image": "https://images.unsplash.com/photo-1573140247632-f84660f67127?auto=format&fit=crop&w=400&q=80", "desc": "Cheese garlic breadsticks."},
        ]
      }
    ]
  },
];
