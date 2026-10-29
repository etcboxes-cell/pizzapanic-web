extends Node2D
## Pizza Panic: original landscape restaurant time-management demo.
## Gameplay: select a party -> appropriate-sized table -> take order -> serve -> collect -> clean.

const W := 1280.0
const H := 720.0
# Ten individually tuned restaurant shifts. Level 1 retains its original rules.
const LEVELS := [
    {"name":"Grand Opening", "goal":80,"time":80.0,"party_cap":8,"spawn":7.2,"queue_decay":1.05,"table_decay":1.0,"cook":1.0,"vip_every":7,"bonus":0,"challenge":"Serve 4 guests and learn the restaurant workflow","kind":"guests","target":4,"brief":"WELCOME! Practice seating, orders, cooking, serving, payment and cleanup. Arrivals are spaced so you can learn. Mistakes are recoverable."},
    {"name":"Couples & Friends", "goal":80,"time":85.0,"party_cap":9,"spawn":6.3,"queue_decay":1.08,"table_decay":1.0,"cook":1.0,"vip_every":7,"bonus":0,"challenge":"Serve 7 guests from parties of one or two","kind":"guests","target":7,"brief":"Only solo customers and couples arrive today. All three starter tables are yellow with two seats. Starting on Level 3 you can pay to convert any available yellow table to red, adding two seats."},
    {"name":"Bigger Parties", "goal":85,"time":90.0,"party_cap":10,"spawn":6.4,"queue_decay":1.10,"table_decay":1.0,"cook":1.0,"vip_every":7,"bonus":0,"challenge":"Clean 3 tables with no more than 3 dirty at once","kind":"clean","target":3,"brief":"NEW: Buy a RED TABLE conversion in the STORE (150 coins per table). Groups of three and four begin once you own at least one red table. You can convert additional yellow tables whenever you have enough saved coins. Missions are optional."},
    {"name":"VIP Visit", "goal":85,"time":95.0,"party_cap":11,"spawn":5.8,"queue_decay":1.12,"table_decay":1.0,"cook":1.0,"vip_every":3,"bonus":0,"challenge":"Serve 1 VIP party","kind":"vip","target":1,"brief":"VIP parties have less patience but pay more. Prioritize their orders and collect payments."},
    {"name":"Picky Guests Ahead", "goal":90,"time":100.0,"party_cap":11,"spawn":5.8,"queue_decay":1.14,"table_decay":1.0,"cook":1.0,"vip_every":6,"bonus":0,"challenge":"Serve 7 guests during your first Rush Day","kind":"guests","target":7,"brief":"Customers are becoming pickier. Practice fast service; ingredient requests begin on Day 6."},
    {"name":"First Ingredients!", "goal":90,"time":115.0,"party_cap":10,"spawn":7.0,"queue_decay":1.12,"table_decay":1.0,"cook":1.1,"vip_every":6,"bonus":0,"challenge":"Prepare 2 pizzas with the requested topping","kind":"correct","target":2,"brief":"NEW: single-topping orders. Check each ticket before cooking. The full workflow remains unchanged."},
    {"name":"Double Pizza Orders", "goal":95,"time":120.0,"party_cap":11,"spawn":7.0,"queue_decay":1.15,"table_decay":1.0,"cook":1.0,"vip_every":5,"bonus":0,"challenge":"Serve 7 guests while handling double pizzas","kind":"guests","target":7,"brief":"NEW: some tables order TWO pizzas. Deliver both from pickup before anyone at that table starts eating."},
    {"name":"Birthday Reservation", "goal":95,"time":125.0,"party_cap":12,"spawn":6.8,"queue_decay":1.14,"table_decay":1.0,"cook":1.0,"vip_every":6,"bonus":0,"challenge":"Seat AND serve the birthday reservation","kind":"reservation","target":1,"brief":"A birthday reservation arrives 25 seconds into the shift. With a red four-seat table it is a party of FOUR; until then a pair will arrive. Seat and serve them!"},
    {"name":"Speed and Tips", "goal":100,"time":130.0,"party_cap":12,"spawn":6.8,"queue_decay":1.16,"table_decay":1.0,"cook":1.0,"vip_every":5,"bonus":0,"challenge":"Serve 7 guests with strong tips","kind":"guests","target":7,"brief":"NEW: your tip depends more strongly on customer patience. Watch each table clock and serve quickly."},
    {"name":"Ultimate Pizza Rush", "goal":105,"time":135.0,"party_cap":13,"spawn":6.4,"queue_decay":1.18,"table_decay":1.0,"cook":1.1,"vip_every":4,"bonus":0,"challenge":"Prepare 3 correct pizzas in the Rush Day","kind":"correct","target":3,"brief":"Prepare each pizza with one topping. Always use ORDER DISH, COOK, PICKUP BAR, delivery, payment and dishes."},
    {"name":"Two-Ingredient Recipes", "goal":105,"time":140.0,"party_cap":13,"spawn":7.0,"queue_decay":1.17,"table_decay":1.0,"cook":1.0,"vip_every":5,"bonus":0,"challenge":"Choose cheese, pepperoni and mushrooms for three correct orders.","kind":"ingredients","target":3,"brief":"NEW: custom orders need TWO exact toppings. Double-pizza tables still require two separately delivered pizzas."},
    {"name":"Topping Trouble", "goal":110,"time":145.0,"party_cap":14,"spawn":6.0,"queue_decay":1.19,"table_decay":1.0,"cook":1.0,"vip_every":5,"bonus":0,"challenge":"Match four different topping combinations.","kind":"ingredients","target":4,"brief":"Match four different topping combinations."},
    {"name":"Double Dirty Dishes", "goal":110,"time":150.0,"party_cap":14,"spawn":4.0,"queue_decay":1.18,"table_decay":1.0,"cook":1.0,"vip_every":5,"bonus":0,"challenge":"Prepare five table-specific orders correctly.","kind":"ingredients","target":4,"brief":"NEW: occasional double dirty dishes. A dish cart helps, but buying it is not required to play."},
    {"name":"Fresh From the Market", "goal":115,"time":155.0,"party_cap":15,"spawn":4.0,"queue_decay":1.20,"table_decay":1.0,"cook":1.0,"vip_every":5,"bonus":0,"challenge":"New toppings: peppers, olives and basil!","kind":"ingredients","target":4,"brief":"New toppings: peppers, olives and basil!"},
    {"name":"Faster Kitchen", "goal":120,"time":160.0,"party_cap":15,"spawn":4.0,"queue_decay":1.21,"table_decay":1.0,"cook":1.0,"vip_every":5,"bonus":0,"challenge":"Prepare six custom table orders with correct toppings.","kind":"ingredients","target":5,"brief":"NEW: buy the 3-dish cart and Turbo Oven from Day 15. Turbo Oven cooks in 3 seconds."},
    {"name":"Grand Restaurant Opening", "goal":120,"time":165.0,"party_cap":16,"spawn":4.0,"queue_decay":1.20,"table_decay":1.0,"cook":1.0,"vip_every":4,"bonus":0,"challenge":"Serve six accurate pizzas at the larger restaurant.","kind":"ingredients","target":5,"brief":"Expanded dining area and three-topping orders. An expansion helps, but you may play without buying one."},
    {"name":"Robot Assistance", "goal":125,"time":170.0,"party_cap":16,"spawn":4.0,"queue_decay":1.22,"table_decay":1.0,"cook":1.0,"vip_every":4,"bonus":0,"challenge":"Impress the food critic with seven accurate recipes.","kind":"ingredients","target":6,"brief":"NEW: use the Robot Waiter to automatically deliver pizzas, while you handle orders and table cleaning."},
    {"name":"Birthday Pizza Party", "goal":130,"time":175.0,"party_cap":17,"spawn":4.0,"queue_decay":1.23,"table_decay":1.0,"cook":1.0,"vip_every":4,"bonus":0,"challenge":"Celebrate the birthday party with seven correct orders.","kind":"ingredients","target":6,"brief":"Celebrate the birthday party with seven correct orders."},
    {"name":"Pizza Championship Prep", "goal":135,"time":180.0,"party_cap":18,"spawn":4.0,"queue_decay":1.24,"table_decay":1.0,"cook":1.0,"vip_every":4,"bonus":0,"challenge":"Deliver eight correct pizzas to their matching tables.","kind":"ingredients","target":7,"brief":"The busiest service yet. Use all your restaurant skills; the Entertainer unlocks at Day 20."},
    {"name":"Pizza Panic Championship", "goal":140,"time":190.0,"party_cap":18,"spawn":4.0,"queue_decay":1.25,"table_decay":1.0,"cook":1.0,"vip_every":4,"bonus":0,"challenge":"Stage finale: nine accurate pizzas and master the whole restaurant.","kind":"ingredients","target":8,"brief":"Stage finale: nine accurate pizzas and master the whole restaurant."},
    {"name":"Lunch Line","goal":126,"time":155.6,"party_cap":15,"spawn":6.08,"queue_decay":1.192,"table_decay":1.0,"cook":1.0,"vip_every":6,"bonus":0,"challenge":"Prepare 7 correct customized pizzas","kind":"ingredients","target":7,"brief":"CHAPTER 2/5: Growing Business. Serve guests and manage the kitchen. Focus: Lunch Line. Complete the cash goal; the special mission is optional. Replay to repair reputation."},
    {"name":"Lunch Line II","goal":127,"time":156.2,"party_cap":16,"spawn":6.07,"queue_decay":1.194,"table_decay":1.0,"cook":1.0,"vip_every":6,"bonus":0,"challenge":"Serve 5 guests with good timing","kind":"guests","target":5,"brief":"CHAPTER 2/5: Growing Business. Serve guests and manage the kitchen. Focus: Lunch Line II. Complete the cash goal; the special mission is optional. Replay to repair reputation."},
    {"name":"Neighborhood Families","goal":129,"time":156.9,"party_cap":17,"spawn":6.05,"queue_decay":1.196,"table_decay":1.0,"cook":1.0,"vip_every":6,"bonus":0,"challenge":"Deliver 6 correct pizzas","kind":"correct","target":6,"brief":"CHAPTER 2/5: Growing Business. Serve guests and manage the kitchen. Focus: Neighborhood Families. Complete the cash goal; the special mission is optional. Replay to repair reputation."},
    {"name":"Neighborhood Families II","goal":130,"time":157.5,"party_cap":18,"spawn":6.04,"queue_decay":1.198,"table_decay":1.0,"cook":1.0,"vip_every":6,"bonus":0,"challenge":"Serve 1 VIP parties","kind":"vip","target":1,"brief":"CHAPTER 2/5: Growing Business. Serve guests and manage the kitchen. Focus: Neighborhood Families II. Complete the cash goal; the special mission is optional. Replay to repair reputation."},
    {"name":"Growing Business Mini-Game Day","goal":132,"time":158.1,"party_cap":15,"spawn":6.02,"queue_decay":1.2,"table_decay":1.0,"cook":1.0,"vip_every":6,"bonus":0,"challenge":"Clean 5 tables","kind":"clean","target":5,"brief":"CHAPTER 2/5: Growing Business. Milestone mini-game after this shift! Focus: Growing Business Mini-Game Day. Complete the cash goal; the special mission is optional. Replay to repair reputation."},
    {"name":"Express Service II","goal":133,"time":158.7,"party_cap":16,"spawn":6.0,"queue_decay":1.202,"table_decay":1.0,"cook":1.0,"vip_every":6,"bonus":0,"challenge":"Seat 2 large parties","kind":"large","target":2,"brief":"CHAPTER 2/5: Growing Business. Serve guests and manage the kitchen. Focus: Express Service II. Complete the cash goal; the special mission is optional. Replay to repair reputation."},
    {"name":"Fast Payments","goal":135,"time":159.3,"party_cap":17,"spawn":5.99,"queue_decay":1.204,"table_decay":1.0,"cook":1.0,"vip_every":6,"bonus":0,"challenge":"Prepare 7 correct customized pizzas","kind":"ingredients","target":7,"brief":"CHAPTER 2/5: Growing Business. Serve guests and manage the kitchen. Focus: Fast Payments. Complete the cash goal; the special mission is optional. Replay to repair reputation."},
    {"name":"Fast Payments II","goal":136,"time":160.0,"party_cap":18,"spawn":5.97,"queue_decay":1.206,"table_decay":1.0,"cook":1.0,"vip_every":6,"bonus":0,"challenge":"Deliver 5 correct pizzas","kind":"correct","target":5,"brief":"CHAPTER 2/5: Growing Business. Serve guests and manage the kitchen. Focus: Fast Payments II. Complete the cash goal; the special mission is optional. Replay to repair reputation."},
    {"name":"Weekend Crowd","goal":138,"time":160.6,"party_cap":15,"spawn":5.96,"queue_decay":1.208,"table_decay":1.0,"cook":1.0,"vip_every":6,"bonus":0,"challenge":"Serve 7 guests with good timing","kind":"guests","target":7,"brief":"CHAPTER 2/5: Growing Business. Serve guests and manage the kitchen. Focus: Weekend Crowd. Complete the cash goal; the special mission is optional. Replay to repair reputation."},
    {"name":"Growing Business Mini-Game Day","goal":139,"time":161.2,"party_cap":16,"spawn":5.94,"queue_decay":1.21,"table_decay":1.0,"cook":1.0,"vip_every":6,"bonus":0,"challenge":"Prepare 8 correct customized pizzas","kind":"ingredients","target":8,"brief":"CHAPTER 2/5: Growing Business. Milestone mini-game after this shift! Focus: Growing Business Mini-Game Day. Complete the cash goal; the special mission is optional. Replay to repair reputation."},
    {"name":"Topping Festival","goal":140,"time":161.8,"party_cap":17,"spawn":5.92,"queue_decay":1.212,"table_decay":1.0,"cook":1.0,"vip_every":6,"bonus":0,"challenge":"Prepare 6 correct customized pizzas","kind":"ingredients","target":6,"brief":"CHAPTER 2/5: Growing Business. Serve guests and manage the kitchen. Focus: Topping Festival. Complete the cash goal; the special mission is optional. Replay to repair reputation."},
    {"name":"Topping Festival II","goal":142,"time":162.4,"party_cap":18,"spawn":5.91,"queue_decay":1.214,"table_decay":1.0,"cook":1.0,"vip_every":6,"bonus":0,"challenge":"Serve 7 guests with good timing","kind":"guests","target":7,"brief":"CHAPTER 2/5: Growing Business. Serve guests and manage the kitchen. Focus: Topping Festival II. Complete the cash goal; the special mission is optional. Replay to repair reputation."},
    {"name":"Big Birthday","goal":143,"time":163.1,"party_cap":15,"spawn":5.89,"queue_decay":1.216,"table_decay":1.0,"cook":1.0,"vip_every":6,"bonus":0,"challenge":"Deliver 8 correct pizzas","kind":"correct","target":8,"brief":"CHAPTER 2/5: Growing Business. Serve guests and manage the kitchen. Focus: Big Birthday. Complete the cash goal; the special mission is optional. Replay to repair reputation."},
    {"name":"Big Birthday II","goal":145,"time":163.7,"party_cap":16,"spawn":5.88,"queue_decay":1.218,"table_decay":1.0,"cook":1.0,"vip_every":6,"bonus":0,"challenge":"Serve 1 VIP parties","kind":"vip","target":1,"brief":"CHAPTER 2/5: Growing Business. Serve guests and manage the kitchen. Focus: Big Birthday II. Complete the cash goal; the special mission is optional. Replay to repair reputation."},
    {"name":"Growing Business Mini-Game Day","goal":146,"time":164.3,"party_cap":18,"spawn":5.86,"queue_decay":1.22,"table_decay":1.0,"cook":1.0,"vip_every":6,"bonus":0,"challenge":"Clean 7 tables","kind":"clean","target":7,"brief":"CHAPTER 2/5: Growing Business. Milestone mini-game after this shift! Focus: Growing Business Mini-Game Day. Complete the cash goal; the special mission is optional. Replay to repair reputation."},
    {"name":"Special Deliveries II","goal":148,"time":164.9,"party_cap":19,"spawn":5.84,"queue_decay":1.222,"table_decay":1.0,"cook":1.0,"vip_every":6,"bonus":0,"challenge":"Seat 2 large parties","kind":"large","target":2,"brief":"CHAPTER 2/5: Growing Business. Serve guests and manage the kitchen. Focus: Special Deliveries II. Complete the cash goal; the special mission is optional. Replay to repair reputation."},
    {"name":"Chef Showdown","goal":149,"time":165.5,"party_cap":16,"spawn":5.83,"queue_decay":1.224,"table_decay":1.0,"cook":1.0,"vip_every":6,"bonus":0,"challenge":"Prepare 6 correct customized pizzas","kind":"ingredients","target":6,"brief":"CHAPTER 2/5: Growing Business. Serve guests and manage the kitchen. Focus: Chef Showdown. Complete the cash goal; the special mission is optional. Replay to repair reputation."},
    {"name":"Chef Showdown II","goal":151,"time":166.2,"party_cap":17,"spawn":5.81,"queue_decay":1.226,"table_decay":1.0,"cook":1.0,"vip_every":6,"bonus":0,"challenge":"Deliver 7 correct pizzas","kind":"correct","target":7,"brief":"CHAPTER 2/5: Growing Business. Serve guests and manage the kitchen. Focus: Chef Showdown II. Complete the cash goal; the special mission is optional. Replay to repair reputation."},
    {"name":"Neighborhood Favorite","goal":152,"time":166.8,"party_cap":18,"spawn":5.8,"queue_decay":1.228,"table_decay":1.0,"cook":1.0,"vip_every":6,"bonus":0,"challenge":"Serve 8 guests with good timing","kind":"guests","target":8,"brief":"CHAPTER 2/5: Growing Business. Serve guests and manage the kitchen. Focus: Neighborhood Favorite. Complete the cash goal; the special mission is optional. Replay to repair reputation."},
    {"name":"Growing Business Championship","goal":154,"time":167.4,"party_cap":19,"spawn":5.78,"queue_decay":1.23,"table_decay":1.0,"cook":1.0,"vip_every":6,"bonus":0,"challenge":"Prepare 6 correct customized pizzas","kind":"ingredients","target":6,"brief":"CHAPTER 2/5: Growing Business. Milestone mini-game after this shift! Focus: Growing Business Championship. Complete the cash goal; the special mission is optional. Replay to repair reputation."},
    {"name":"Lunch Hour Legends","goal":155,"time":168.0,"party_cap":16,"spawn":5.76,"queue_decay":1.232,"table_decay":1.0,"cook":1.0,"vip_every":5,"bonus":0,"challenge":"Prepare 7 correct customized pizzas","kind":"ingredients","target":7,"brief":"CHAPTER 3/5: City Favorite. Serve guests and manage the kitchen. Focus: Lunch Hour Legends. Complete the cash goal; the special mission is optional. Replay to repair reputation."},
    {"name":"Lunch Hour Legends II","goal":156,"time":168.6,"party_cap":17,"spawn":5.75,"queue_decay":1.234,"table_decay":1.0,"cook":1.0,"vip_every":5,"bonus":0,"challenge":"Serve 8 guests with good timing","kind":"guests","target":8,"brief":"CHAPTER 3/5: City Favorite. Serve guests and manage the kitchen. Focus: Lunch Hour Legends II. Complete the cash goal; the special mission is optional. Replay to repair reputation."},
    {"name":"VIP Reservations","goal":158,"time":169.3,"party_cap":18,"spawn":5.73,"queue_decay":1.236,"table_decay":1.0,"cook":1.0,"vip_every":5,"bonus":0,"challenge":"Deliver 7 correct pizzas","kind":"correct","target":7,"brief":"CHAPTER 3/5: City Favorite. Serve guests and manage the kitchen. Focus: VIP Reservations. Complete the cash goal; the special mission is optional. Replay to repair reputation."},
    {"name":"VIP Reservations II","goal":159,"time":169.9,"party_cap":19,"spawn":5.72,"queue_decay":1.238,"table_decay":1.0,"cook":1.0,"vip_every":5,"bonus":0,"challenge":"Serve 2 VIP parties","kind":"vip","target":2,"brief":"CHAPTER 3/5: City Favorite. Serve guests and manage the kitchen. Focus: VIP Reservations II. Complete the cash goal; the special mission is optional. Replay to repair reputation."},
    {"name":"City Favorite Mini-Game Day","goal":161,"time":170.5,"party_cap":16,"spawn":5.7,"queue_decay":1.24,"table_decay":1.0,"cook":1.0,"vip_every":5,"bonus":0,"challenge":"Clean 9 tables","kind":"clean","target":9,"brief":"CHAPTER 3/5: City Favorite. Milestone mini-game after this shift! Focus: City Favorite Mini-Game Day. Complete the cash goal; the special mission is optional. Replay to repair reputation."},
    {"name":"Double Order Day II","goal":162,"time":171.1,"party_cap":17,"spawn":5.68,"queue_decay":1.242,"table_decay":1.0,"cook":1.0,"vip_every":5,"bonus":0,"challenge":"Seat 2 large parties","kind":"large","target":2,"brief":"CHAPTER 3/5: City Favorite. Serve guests and manage the kitchen. Focus: Double Order Day II. Complete the cash goal; the special mission is optional. Replay to repair reputation."},
    {"name":"Busy Sidewalk","goal":164,"time":171.7,"party_cap":18,"spawn":5.67,"queue_decay":1.244,"table_decay":1.0,"cook":1.0,"vip_every":5,"bonus":0,"challenge":"Prepare 8 correct customized pizzas","kind":"ingredients","target":8,"brief":"CHAPTER 3/5: City Favorite. Serve guests and manage the kitchen. Focus: Busy Sidewalk. Complete the cash goal; the special mission is optional. Replay to repair reputation."},
    {"name":"Busy Sidewalk II","goal":165,"time":172.4,"party_cap":19,"spawn":5.65,"queue_decay":1.246,"table_decay":1.0,"cook":1.0,"vip_every":5,"bonus":0,"challenge":"Deliver 9 correct pizzas","kind":"correct","target":9,"brief":"CHAPTER 3/5: City Favorite. Serve guests and manage the kitchen. Focus: Busy Sidewalk II. Complete the cash goal; the special mission is optional. Replay to repair reputation."},
    {"name":"Kitchen Focus","goal":167,"time":173.0,"party_cap":16,"spawn":5.64,"queue_decay":1.248,"table_decay":1.0,"cook":1.0,"vip_every":5,"bonus":0,"challenge":"Serve 7 guests with good timing","kind":"guests","target":7,"brief":"CHAPTER 3/5: City Favorite. Serve guests and manage the kitchen. Focus: Kitchen Focus. Complete the cash goal; the special mission is optional. Replay to repair reputation."},
    {"name":"City Favorite Mini-Game Day","goal":168,"time":173.6,"party_cap":17,"spawn":5.62,"queue_decay":1.25,"table_decay":1.0,"cook":1.0,"vip_every":5,"bonus":0,"challenge":"Prepare 8 correct customized pizzas","kind":"ingredients","target":8,"brief":"CHAPTER 3/5: City Favorite. Milestone mini-game after this shift! Focus: City Favorite Mini-Game Day. Complete the cash goal; the special mission is optional. Replay to repair reputation."},
    {"name":"Late Lunch","goal":169,"time":174.2,"party_cap":18,"spawn":5.6,"queue_decay":1.252,"table_decay":1.0,"cook":1.0,"vip_every":5,"bonus":0,"challenge":"Prepare 9 correct customized pizzas","kind":"ingredients","target":9,"brief":"CHAPTER 3/5: City Favorite. Serve guests and manage the kitchen. Focus: Late Lunch. Complete the cash goal; the special mission is optional. Replay to repair reputation."},
    {"name":"Late Lunch II","goal":171,"time":174.8,"party_cap":20,"spawn":5.59,"queue_decay":1.254,"table_decay":1.0,"cook":1.0,"vip_every":5,"bonus":0,"challenge":"Serve 7 guests with good timing","kind":"guests","target":7,"brief":"CHAPTER 3/5: City Favorite. Serve guests and manage the kitchen. Focus: Late Lunch II. Complete the cash goal; the special mission is optional. Replay to repair reputation."},
    {"name":"The Food Critic","goal":172,"time":175.5,"party_cap":17,"spawn":5.57,"queue_decay":1.256,"table_decay":1.0,"cook":1.0,"vip_every":5,"bonus":0,"challenge":"Deliver 8 correct pizzas","kind":"correct","target":8,"brief":"CHAPTER 3/5: City Favorite. Serve guests and manage the kitchen. Focus: The Food Critic. Complete the cash goal; the special mission is optional. Replay to repair reputation."},
    {"name":"The Food Critic II","goal":174,"time":176.1,"party_cap":18,"spawn":5.56,"queue_decay":1.258,"table_decay":1.0,"cook":1.0,"vip_every":5,"bonus":0,"challenge":"Serve 2 VIP parties","kind":"vip","target":2,"brief":"CHAPTER 3/5: City Favorite. Serve guests and manage the kitchen. Focus: The Food Critic II. Complete the cash goal; the special mission is optional. Replay to repair reputation."},
    {"name":"City Favorite Mini-Game Day","goal":175,"time":176.7,"party_cap":19,"spawn":5.54,"queue_decay":1.26,"table_decay":1.0,"cook":1.0,"vip_every":5,"bonus":0,"challenge":"Clean 7 tables","kind":"clean","target":7,"brief":"CHAPTER 3/5: City Favorite. Milestone mini-game after this shift! Focus: City Favorite Mini-Game Day. Complete the cash goal; the special mission is optional. Replay to repair reputation."},
    {"name":"Fast Pizza Night II","goal":177,"time":177.3,"party_cap":20,"spawn":5.52,"queue_decay":1.262,"table_decay":1.0,"cook":1.0,"vip_every":5,"bonus":0,"challenge":"Seat 2 large parties","kind":"large","target":2,"brief":"CHAPTER 3/5: City Favorite. Serve guests and manage the kitchen. Focus: Fast Pizza Night II. Complete the cash goal; the special mission is optional. Replay to repair reputation."},
    {"name":"Family Reunion","goal":178,"time":177.9,"party_cap":17,"spawn":5.51,"queue_decay":1.264,"table_decay":1.0,"cook":1.0,"vip_every":5,"bonus":0,"challenge":"Prepare 10 correct customized pizzas","kind":"ingredients","target":10,"brief":"CHAPTER 3/5: City Favorite. Serve guests and manage the kitchen. Focus: Family Reunion. Complete the cash goal; the special mission is optional. Replay to repair reputation."},
    {"name":"Family Reunion II","goal":180,"time":178.6,"party_cap":18,"spawn":5.49,"queue_decay":1.266,"table_decay":1.0,"cook":1.0,"vip_every":5,"bonus":0,"challenge":"Deliver 8 correct pizzas","kind":"correct","target":8,"brief":"CHAPTER 3/5: City Favorite. Serve guests and manage the kitchen. Focus: Family Reunion II. Complete the cash goal; the special mission is optional. Replay to repair reputation."},
    {"name":"City Favorite Finale","goal":181,"time":179.2,"party_cap":19,"spawn":5.48,"queue_decay":1.268,"table_decay":1.0,"cook":1.0,"vip_every":5,"bonus":0,"challenge":"Serve 9 guests with good timing","kind":"guests","target":9,"brief":"CHAPTER 3/5: City Favorite. Serve guests and manage the kitchen. Focus: City Favorite Finale. Complete the cash goal; the special mission is optional. Replay to repair reputation."},
    {"name":"City Favorite Championship","goal":183,"time":179.8,"party_cap":20,"spawn":5.46,"queue_decay":1.27,"table_decay":1.0,"cook":1.0,"vip_every":5,"bonus":0,"challenge":"Prepare 10 correct customized pizzas","kind":"ingredients","target":10,"brief":"CHAPTER 3/5: City Favorite. Milestone mini-game after this shift! Focus: City Favorite Championship. Complete the cash goal; the special mission is optional. Replay to repair reputation."},
    {"name":"New Restaurant Buzz","goal":184,"time":180.4,"party_cap":17,"spawn":5.44,"queue_decay":1.272,"table_decay":1.0,"cook":1.0,"vip_every":4,"bonus":0,"challenge":"Prepare 8 correct customized pizzas","kind":"ingredients","target":8,"brief":"CHAPTER 4/5: Pizza Empire. Serve guests and manage the kitchen. Focus: New Restaurant Buzz. Complete the cash goal; the special mission is optional. Replay to repair reputation."},
    {"name":"New Restaurant Buzz II","goal":185,"time":181.0,"party_cap":18,"spawn":5.43,"queue_decay":1.274,"table_decay":1.0,"cook":1.0,"vip_every":4,"bonus":0,"challenge":"Serve 9 guests with good timing","kind":"guests","target":9,"brief":"CHAPTER 4/5: Pizza Empire. Serve guests and manage the kitchen. Focus: New Restaurant Buzz II. Complete the cash goal; the special mission is optional. Replay to repair reputation."},
    {"name":"Tables in Motion","goal":187,"time":181.7,"party_cap":19,"spawn":5.41,"queue_decay":1.276,"table_decay":1.0,"cook":1.0,"vip_every":4,"bonus":0,"challenge":"Deliver 10 correct pizzas","kind":"correct","target":10,"brief":"CHAPTER 4/5: Pizza Empire. Serve guests and manage the kitchen. Focus: Tables in Motion. Complete the cash goal; the special mission is optional. Replay to repair reputation."},
    {"name":"Tables in Motion II","goal":188,"time":182.3,"party_cap":20,"spawn":5.4,"queue_decay":1.278,"table_decay":1.0,"cook":1.0,"vip_every":4,"bonus":0,"challenge":"Serve 2 VIP parties","kind":"vip","target":2,"brief":"CHAPTER 4/5: Pizza Empire. Serve guests and manage the kitchen. Focus: Tables in Motion II. Complete the cash goal; the special mission is optional. Replay to repair reputation."},
    {"name":"Pizza Empire Mini-Game Day","goal":190,"time":182.9,"party_cap":17,"spawn":5.38,"queue_decay":1.28,"table_decay":1.0,"cook":1.0,"vip_every":4,"bonus":0,"challenge":"Clean 9 tables","kind":"clean","target":9,"brief":"CHAPTER 4/5: Pizza Empire. Milestone mini-game after this shift! Focus: Pizza Empire Mini-Game Day. Complete the cash goal; the special mission is optional. Replay to repair reputation."},
    {"name":"High Volume Orders II","goal":191,"time":183.5,"party_cap":18,"spawn":5.36,"queue_decay":1.282,"table_decay":1.0,"cook":1.0,"vip_every":4,"bonus":0,"challenge":"Seat 3 large parties","kind":"large","target":3,"brief":"CHAPTER 4/5: Pizza Empire. Serve guests and manage the kitchen. Focus: High Volume Orders II. Complete the cash goal; the special mission is optional. Replay to repair reputation."},
    {"name":"Demanding Diners","goal":193,"time":184.1,"party_cap":19,"spawn":5.35,"queue_decay":1.284,"table_decay":1.0,"cook":1.0,"vip_every":4,"bonus":0,"challenge":"Prepare 8 correct customized pizzas","kind":"ingredients","target":8,"brief":"CHAPTER 4/5: Pizza Empire. Serve guests and manage the kitchen. Focus: Demanding Diners. Complete the cash goal; the special mission is optional. Replay to repair reputation."},
    {"name":"Demanding Diners II","goal":194,"time":184.8,"party_cap":20,"spawn":5.33,"queue_decay":1.286,"table_decay":1.0,"cook":1.0,"vip_every":4,"bonus":0,"challenge":"Deliver 9 correct pizzas","kind":"correct","target":9,"brief":"CHAPTER 4/5: Pizza Empire. Serve guests and manage the kitchen. Focus: Demanding Diners II. Complete the cash goal; the special mission is optional. Replay to repair reputation."},
    {"name":"Kitchen Coordination","goal":196,"time":185.4,"party_cap":18,"spawn":5.32,"queue_decay":1.288,"table_decay":1.0,"cook":1.0,"vip_every":4,"bonus":0,"challenge":"Serve 10 guests with good timing","kind":"guests","target":10,"brief":"CHAPTER 4/5: Pizza Empire. Serve guests and manage the kitchen. Focus: Kitchen Coordination. Complete the cash goal; the special mission is optional. Replay to repair reputation."},
    {"name":"Pizza Empire Mini-Game Day","goal":197,"time":186.0,"party_cap":19,"spawn":5.3,"queue_decay":1.29,"table_decay":1.0,"cook":1.0,"vip_every":4,"bonus":0,"challenge":"Prepare 8 correct customized pizzas","kind":"ingredients","target":8,"brief":"CHAPTER 4/5: Pizza Empire. Milestone mini-game after this shift! Focus: Pizza Empire Mini-Game Day. Complete the cash goal; the special mission is optional. Replay to repair reputation."},
    {"name":"Chef Challenge","goal":198,"time":186.6,"party_cap":20,"spawn":5.28,"queue_decay":1.292,"table_decay":1.0,"cook":1.0,"vip_every":4,"bonus":0,"challenge":"Prepare 10 correct customized pizzas","kind":"ingredients","target":10,"brief":"CHAPTER 4/5: Pizza Empire. Serve guests and manage the kitchen. Focus: Chef Challenge. Complete the cash goal; the special mission is optional. Replay to repair reputation."},
    {"name":"Chef Challenge II","goal":200,"time":187.2,"party_cap":21,"spawn":5.27,"queue_decay":1.294,"table_decay":1.0,"cook":1.0,"vip_every":4,"bonus":0,"challenge":"Serve 10 guests with good timing","kind":"guests","target":10,"brief":"CHAPTER 4/5: Pizza Empire. Serve guests and manage the kitchen. Focus: Chef Challenge II. Complete the cash goal; the special mission is optional. Replay to repair reputation."},
    {"name":"Topping Precision","goal":201,"time":187.9,"party_cap":18,"spawn":5.25,"queue_decay":1.296,"table_decay":1.0,"cook":1.0,"vip_every":4,"bonus":0,"challenge":"Deliver 9 correct pizzas","kind":"correct","target":9,"brief":"CHAPTER 4/5: Pizza Empire. Serve guests and manage the kitchen. Focus: Topping Precision. Complete the cash goal; the special mission is optional. Replay to repair reputation."},
    {"name":"Topping Precision II","goal":203,"time":188.5,"party_cap":19,"spawn":5.24,"queue_decay":1.298,"table_decay":1.0,"cook":1.0,"vip_every":4,"bonus":0,"challenge":"Serve 2 VIP parties","kind":"vip","target":2,"brief":"CHAPTER 4/5: Pizza Empire. Serve guests and manage the kitchen. Focus: Topping Precision II. Complete the cash goal; the special mission is optional. Replay to repair reputation."},
    {"name":"Pizza Empire Mini-Game Day","goal":204,"time":189.1,"party_cap":20,"spawn":5.22,"queue_decay":1.3,"table_decay":1.0,"cook":1.0,"vip_every":4,"bonus":0,"challenge":"Clean 10 tables","kind":"clean","target":10,"brief":"CHAPTER 4/5: Pizza Empire. Milestone mini-game after this shift! Focus: Pizza Empire Mini-Game Day. Complete the cash goal; the special mission is optional. Replay to repair reputation."},
    {"name":"Dinner Showdown II","goal":206,"time":189.7,"party_cap":21,"spawn":5.2,"queue_decay":1.302,"table_decay":1.0,"cook":1.0,"vip_every":4,"bonus":0,"challenge":"Seat 3 large parties","kind":"large","target":3,"brief":"CHAPTER 4/5: Pizza Empire. Serve guests and manage the kitchen. Focus: Dinner Showdown II. Complete the cash goal; the special mission is optional. Replay to repair reputation."},
    {"name":"City Food Festival","goal":207,"time":190.3,"party_cap":18,"spawn":5.19,"queue_decay":1.304,"table_decay":1.0,"cook":1.0,"vip_every":4,"bonus":0,"challenge":"Prepare 10 correct customized pizzas","kind":"ingredients","target":10,"brief":"CHAPTER 4/5: Pizza Empire. Serve guests and manage the kitchen. Focus: City Food Festival. Complete the cash goal; the special mission is optional. Replay to repair reputation."},
    {"name":"City Food Festival II","goal":209,"time":191.0,"party_cap":19,"spawn":5.17,"queue_decay":1.306,"table_decay":1.0,"cook":1.0,"vip_every":4,"bonus":0,"challenge":"Deliver 10 correct pizzas","kind":"correct","target":10,"brief":"CHAPTER 4/5: Pizza Empire. Serve guests and manage the kitchen. Focus: City Food Festival II. Complete the cash goal; the special mission is optional. Replay to repair reputation."},
    {"name":"Empire Expansion","goal":210,"time":191.6,"party_cap":20,"spawn":5.16,"queue_decay":1.308,"table_decay":1.0,"cook":1.0,"vip_every":4,"bonus":0,"challenge":"Serve 9 guests with good timing","kind":"guests","target":9,"brief":"CHAPTER 4/5: Pizza Empire. Serve guests and manage the kitchen. Focus: Empire Expansion. Complete the cash goal; the special mission is optional. Replay to repair reputation."},
    {"name":"Pizza Empire Championship","goal":212,"time":192.2,"party_cap":21,"spawn":5.14,"queue_decay":1.31,"table_decay":1.0,"cook":1.0,"vip_every":4,"bonus":0,"challenge":"Prepare 10 correct customized pizzas","kind":"ingredients","target":10,"brief":"CHAPTER 4/5: Pizza Empire. Milestone mini-game after this shift! Focus: Pizza Empire Championship. Complete the cash goal; the special mission is optional. Replay to repair reputation."},
    {"name":"Legendary Opening","goal":213,"time":192.8,"party_cap":18,"spawn":5.12,"queue_decay":1.312,"table_decay":1.0,"cook":1.0,"vip_every":3,"bonus":0,"challenge":"Prepare 10 correct customized pizzas","kind":"ingredients","target":10,"brief":"CHAPTER 5/5: Pizza Legend. Serve guests and manage the kitchen. Focus: Legendary Opening. Complete the cash goal; the special mission is optional. Replay to repair reputation."},
    {"name":"Legendary Opening II","goal":214,"time":193.4,"party_cap":19,"spawn":5.11,"queue_decay":1.314,"table_decay":1.0,"cook":1.0,"vip_every":3,"bonus":0,"challenge":"Serve 9 guests with good timing","kind":"guests","target":9,"brief":"CHAPTER 5/5: Pizza Legend. Serve guests and manage the kitchen. Focus: Legendary Opening II. Complete the cash goal; the special mission is optional. Replay to repair reputation."},
    {"name":"Table Strategy","goal":216,"time":194.1,"party_cap":20,"spawn":5.09,"queue_decay":1.316,"table_decay":1.0,"cook":1.0,"vip_every":3,"bonus":0,"challenge":"Deliver 10 correct pizzas","kind":"correct","target":10,"brief":"CHAPTER 5/5: Pizza Legend. Serve guests and manage the kitchen. Focus: Table Strategy. Complete the cash goal; the special mission is optional. Replay to repair reputation."},
    {"name":"Table Strategy II","goal":217,"time":194.7,"party_cap":21,"spawn":5.08,"queue_decay":1.318,"table_decay":1.0,"cook":1.0,"vip_every":3,"bonus":0,"challenge":"Serve 2 VIP parties","kind":"vip","target":2,"brief":"CHAPTER 5/5: Pizza Legend. Serve guests and manage the kitchen. Focus: Table Strategy II. Complete the cash goal; the special mission is optional. Replay to repair reputation."},
    {"name":"Pizza Legend Mini-Game Day","goal":219,"time":195.3,"party_cap":18,"spawn":5.06,"queue_decay":1.32,"table_decay":1.0,"cook":1.0,"vip_every":3,"bonus":0,"challenge":"Clean 10 tables","kind":"clean","target":10,"brief":"CHAPTER 5/5: Pizza Legend. Milestone mini-game after this shift! Focus: Pizza Legend Mini-Game Day. Complete the cash goal; the special mission is optional. Replay to repair reputation."},
    {"name":"Express Pizzas II","goal":220,"time":195.9,"party_cap":20,"spawn":5.04,"queue_decay":1.322,"table_decay":1.0,"cook":1.0,"vip_every":3,"bonus":0,"challenge":"Seat 3 large parties","kind":"large","target":3,"brief":"CHAPTER 5/5: Pizza Legend. Serve guests and manage the kitchen. Focus: Express Pizzas II. Complete the cash goal; the special mission is optional. Replay to repair reputation."},
    {"name":"Three-Topping Mastery","goal":222,"time":196.5,"party_cap":21,"spawn":5.03,"queue_decay":1.324,"table_decay":1.0,"cook":1.0,"vip_every":3,"bonus":0,"challenge":"Prepare 10 correct customized pizzas","kind":"ingredients","target":10,"brief":"CHAPTER 5/5: Pizza Legend. Serve guests and manage the kitchen. Focus: Three-Topping Mastery. Complete the cash goal; the special mission is optional. Replay to repair reputation."},
    {"name":"Three-Topping Mastery II","goal":223,"time":197.2,"party_cap":22,"spawn":5.01,"queue_decay":1.326,"table_decay":1.0,"cook":1.0,"vip_every":3,"bonus":0,"challenge":"Deliver 10 correct pizzas","kind":"correct","target":10,"brief":"CHAPTER 5/5: Pizza Legend. Serve guests and manage the kitchen. Focus: Three-Topping Mastery II. Complete the cash goal; the special mission is optional. Replay to repair reputation."},
    {"name":"VIP Marathon","goal":225,"time":197.8,"party_cap":19,"spawn":5.0,"queue_decay":1.328,"table_decay":1.0,"cook":1.0,"vip_every":3,"bonus":0,"challenge":"Serve 10 guests with good timing","kind":"guests","target":10,"brief":"CHAPTER 5/5: Pizza Legend. Serve guests and manage the kitchen. Focus: VIP Marathon. Complete the cash goal; the special mission is optional. Replay to repair reputation."},
    {"name":"Pizza Legend Mini-Game Day","goal":226,"time":198.4,"party_cap":20,"spawn":4.98,"queue_decay":1.33,"table_decay":1.0,"cook":1.0,"vip_every":3,"bonus":0,"challenge":"Prepare 10 correct customized pizzas","kind":"ingredients","target":10,"brief":"CHAPTER 5/5: Pizza Legend. Milestone mini-game after this shift! Focus: Pizza Legend Mini-Game Day. Complete the cash goal; the special mission is optional. Replay to repair reputation."},
    {"name":"Kitchen Pressure","goal":227,"time":199.0,"party_cap":21,"spawn":4.96,"queue_decay":1.332,"table_decay":1.0,"cook":1.0,"vip_every":3,"bonus":0,"challenge":"Prepare 10 correct customized pizzas","kind":"ingredients","target":10,"brief":"CHAPTER 5/5: Pizza Legend. Serve guests and manage the kitchen. Focus: Kitchen Pressure. Complete the cash goal; the special mission is optional. Replay to repair reputation."},
    {"name":"Kitchen Pressure II","goal":229,"time":199.6,"party_cap":22,"spawn":4.95,"queue_decay":1.334,"table_decay":1.0,"cook":1.0,"vip_every":3,"bonus":0,"challenge":"Serve 10 guests with good timing","kind":"guests","target":10,"brief":"CHAPTER 5/5: Pizza Legend. Serve guests and manage the kitchen. Focus: Kitchen Pressure II. Complete the cash goal; the special mission is optional. Replay to repair reputation."},
    {"name":"Rush Hour Legend","goal":230,"time":200.3,"party_cap":19,"spawn":4.93,"queue_decay":1.336,"table_decay":1.0,"cook":1.0,"vip_every":3,"bonus":0,"challenge":"Deliver 10 correct pizzas","kind":"correct","target":10,"brief":"CHAPTER 5/5: Pizza Legend. Serve guests and manage the kitchen. Focus: Rush Hour Legend. Complete the cash goal; the special mission is optional. Replay to repair reputation."},
    {"name":"Rush Hour Legend II","goal":232,"time":200.9,"party_cap":20,"spawn":4.92,"queue_decay":1.338,"table_decay":1.0,"cook":1.0,"vip_every":3,"bonus":0,"challenge":"Serve 2 VIP parties","kind":"vip","target":2,"brief":"CHAPTER 5/5: Pizza Legend. Serve guests and manage the kitchen. Focus: Rush Hour Legend II. Complete the cash goal; the special mission is optional. Replay to repair reputation."},
    {"name":"Pizza Legend Mini-Game Day","goal":233,"time":201.5,"party_cap":21,"spawn":4.9,"queue_decay":1.34,"table_decay":1.0,"cook":1.0,"vip_every":3,"bonus":0,"challenge":"Clean 10 tables","kind":"clean","target":10,"brief":"CHAPTER 5/5: Pizza Legend. Milestone mini-game after this shift! Focus: Pizza Legend Mini-Game Day. Complete the cash goal; the special mission is optional. Replay to repair reputation."},
    {"name":"Customer Happiness II","goal":235,"time":202.1,"party_cap":22,"spawn":4.88,"queue_decay":1.342,"table_decay":1.0,"cook":1.0,"vip_every":3,"bonus":0,"challenge":"Seat 3 large parties","kind":"large","target":3,"brief":"CHAPTER 5/5: Pizza Legend. Serve guests and manage the kitchen. Focus: Customer Happiness II. Complete the cash goal; the special mission is optional. Replay to repair reputation."},
    {"name":"Big Pizza Festival","goal":236,"time":202.7,"party_cap":19,"spawn":4.87,"queue_decay":1.344,"table_decay":1.0,"cook":1.0,"vip_every":3,"bonus":0,"challenge":"Prepare 10 correct customized pizzas","kind":"ingredients","target":10,"brief":"CHAPTER 5/5: Pizza Legend. Serve guests and manage the kitchen. Focus: Big Pizza Festival. Complete the cash goal; the special mission is optional. Replay to repair reputation."},
    {"name":"Big Pizza Festival II","goal":238,"time":203.4,"party_cap":20,"spawn":4.85,"queue_decay":1.346,"table_decay":1.0,"cook":1.0,"vip_every":3,"bonus":0,"challenge":"Deliver 10 correct pizzas","kind":"correct","target":10,"brief":"CHAPTER 5/5: Pizza Legend. Serve guests and manage the kitchen. Focus: Big Pizza Festival II. Complete the cash goal; the special mission is optional. Replay to repair reputation."},
    {"name":"Pizza Legend Finale","goal":239,"time":204.0,"party_cap":21,"spawn":4.84,"queue_decay":1.348,"table_decay":1.0,"cook":1.0,"vip_every":3,"bonus":0,"challenge":"Serve 10 guests with good timing","kind":"guests","target":10,"brief":"CHAPTER 5/5: Pizza Legend. Serve guests and manage the kitchen. Focus: Pizza Legend Finale. Complete the cash goal; the special mission is optional. Replay to repair reputation."},
    {"name":"Pizza Legend Championship","goal":241,"time":204.6,"party_cap":22,"spawn":4.82,"queue_decay":1.35,"table_decay":1.0,"cook":1.0,"vip_every":3,"bonus":0,"challenge":"Prepare 10 correct customized pizzas","kind":"ingredients","target":10,"brief":"CHAPTER 5/5: Pizza Legend. Milestone mini-game after this shift! Focus: Pizza Legend Championship. Complete the cash goal; the special mission is optional. Replay to repair reputation."}
]
# Repeatable challenge shifts; never replace campaign records or existing upgrades.
var endless_mode: bool = false
var endless_wave: int = 1
var endless_best_wave: int = 0
var endless_best_cash: int = 0
var endless_record_payout: Dictionary = {}
var endless_cfg: Dictionary = {}

func configure_endless_wave() -> void:
    # Waves are bounded in difficulty even though the counter is unlimited.
    var intensity: int = mini(18, maxi(0, endless_wave - 1))
    var modifier: String = ["Balanced Service", "Family Tables", "VIP Evening", "Dish Duty", "Pizza Marathon"][int((endless_wave - 1) % 5)]
    var target: int = 6 + mini(7, int(intensity / 3))
    endless_cfg = {
        "name": "Endless Round %d: %s" % [endless_wave, modifier],
        "goal": 100 + intensity * 5,
        "time": 150.0 + minf(45.0, float(intensity * 3)),
        "party_cap": 13 + mini(10, intensity),
        "spawn": 5.5,
        "queue_decay": 1.20 + float(intensity) * 0.023,
        "table_decay": 1.0,
        "cook": 1.0,
        "vip_every": 3 if modifier == "VIP Evening" else 5,
        "bonus": 0,
        "challenge": "Prepare %d accurate pizzas; keep walkouts below 7" % target,
        "kind": "ingredients",
        "target": target,
        "brief": "An optional replayable challenge. Each round gets somewhat busier, with a rotating theme. Complete the cash goal to advance. Only improving your best score on a round grants additional coins. No ads or purchases required."
    }

func open_endless_wave() -> void:
    endless_mode = true
    current_level = LEVELS.size() - 1 # reuse the fully unlocked recipe system
    configure_endless_wave()
    if menu_panel != null: menu_panel.hide()
    if stage_panel != null: stage_panel.hide()
    if showcase_panel != null: showcase_panel.hide()
    prepare_scene()
    show_level_brief()
    panel_title.text = "ENDLESS RESTAURANT  •  ROUND %d" % endless_wave
    start_button.text = "START ENDLESS ROUND %d" % endless_wave
    update_ui()
    queue_redraw()

func begin_endless_from_menu() -> void:
    if running: return
    if int(best_stars.get("99", 0)) <= 0:
        show_stage_select()
        return
    endless_wave = maxi(1, endless_best_wave + 1)
    open_endless_wave()

var current_level: int = 0
# Playtest recorder: privacy-preserving local telemetry (no network, no personal identifiers).
# One JSONL file per game launch, saved outside the project under user://playtest_logs.
var playtest_log_path: String = ""
var playtest_start_msec: int = 0
var playtest_last_table_states: Array[String] = []
var playtest_last_table_parties: Array[int] = []
var playtest_last_queue_ids: Array[int] = []
var playtest_log_button: Button
var playtest_last_action_click_ms: int = -1

func playtest_record(kind: String, extra: Dictionary = {}) -> void:
    if playtest_log_path.is_empty():
        return
    var row: Dictionary = {
        "event": kind,
        "session_ms": Time.get_ticks_msec() - playtest_start_msec,
        "level": current_level + 1,
        "shift_seconds": snappedf(elapsed, 0.01),
        "shift_remaining": snappedf(remaining, 0.01),
        "running": running,
        "shift_cash": cash,
        "wallet": wallet_coins,
        "parties_arrived": next_party_id,
        "parties_waiting": queue.size(),
        "served_guests": served,
        "lost_parties": lost,
        "wrong_pizzas": wrong_count
    }
    row.merge(extra, true)
    var log_file := FileAccess.open(playtest_log_path, FileAccess.READ_WRITE)
    if log_file == null:
        return
    log_file.seek_end()
    log_file.store_line(JSON.stringify(row))
    log_file.close()

func playtest_begin() -> void:
    DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path("user://playtest_logs"))
    playtest_start_msec = Time.get_ticks_msec()
    playtest_log_path = "user://playtest_logs/pizza_panic_%s_%d.jsonl" % [Time.get_datetime_string_from_system().replace(":", "-").replace("T", "_"), Time.get_ticks_msec()]
    var log_file := FileAccess.open(playtest_log_path, FileAccess.WRITE)
    if log_file != null:
        log_file.store_line(JSON.stringify({"event": "recorder_started", "schema_version": 3, "wall_time": Time.get_datetime_string_from_system(), "godot_version": Engine.get_version_info().get("string", "unknown"), "note": "No mouse movement recorded. Click-to-click and action completion timing; local logs only."}))
        log_file.close()

func playtest_snapshot() -> void:
    if not running or shift_paused:
        return
    var now_waiting: Array[int] = []
    for party in queue:
        var pid: int = int(party.get("id", -1))
        now_waiting.append(pid)
        if pid not in playtest_last_queue_ids:
            playtest_record("party_arrived", {"party_id":pid, "party_size":int(party.get("size", 0)), "patience":float(party.get("patience", 0))})
    for pid in playtest_last_queue_ids:
        if pid not in now_waiting:
            playtest_record("party_left_queue", {"party_id":pid})
    playtest_last_queue_ids = now_waiting
    for i in range(tables.size()):
        var table: Dictionary = tables[i]
        var state: String = str(table.get("state", ""))
        var party: Dictionary = table.get("party", {})
        var party_id: int = int(party.get("id", -1))
        if i >= playtest_last_table_states.size():
            playtest_last_table_states.append(state)
            playtest_last_table_parties.append(party_id)
            continue
        if playtest_last_table_states[i] != state or playtest_last_table_parties[i] != party_id:
            playtest_record("table_transition", {"table":i+1, "from":playtest_last_table_states[i], "to":state, "party_id":party_id, "party_size":int(party.get("size", 0)), "patience":float(party.get("patience", 0)), "pizzas_left":int(party.get("pizzas_left", 0)), "custom_order":bool(party.get("custom_order", false))})
            playtest_last_table_states[i] = state
            playtest_last_table_parties[i] = party_id

func playtest_open_folder() -> void:
    var directory: String = ProjectSettings.globalize_path("user://playtest_logs")
    DirAccess.make_dir_recursive_absolute(directory)
    OS.shell_open("file://" + directory.uri_encode().replace("%2F", "/"))
var shift_roster_closed: bool = false
var overtime_seconds: float = 120.0 # legacy state; no forced overtime loss
var closing_announced: bool = false
var highest_unlocked: int = 0
var campaign_win: bool = false
var stage_panel: PanelContainer
var stage_cards: VBoxContainer
var stage_back_button: Button
var stage_select_button: Button
var stage_select_page: int = 0
const STAGE_NAMES := ["GRAND OPENING", "DOWNTOWN DASH", "PIZZA FEVER", "AFTER DARK", "PIZZA EMPIRE"]
const STAGE_TAGLINES := ["Start your pizza dream!", "Bigger crowds, bigger decisions!", "Parties, music and celebrations!", "Serve the city after sunset!", "Build the ultimate pizza business!"]
const DAYS_PER_STAGE := 20
var best_stars: Dictionary = {}
var best_cash: Dictionary = {}
# The review uses the fewest unhappy walkouts achieved for each completed day.
# Replaying a day can repair its review, but cannot erase a different day's review.
var best_walkouts: Dictionary = {}
var best_level_payout: Dictionary = {}

func overall_review_stars() -> float:
    var unhappy: int = 0
    for amount in best_walkouts.values():
        unhappy += int(amount)
    return maxf(0.0, 5.0 - float(unhappy) / 3.0)

# During a shift show the actual penalty immediately, while the saved best
# result is only replaced when a day is completed successfully.
func visible_review_stars() -> float:
    var recorded: int = int(best_walkouts.get(str(current_level), 0))
    var effective: int = maxi(recorded, lost) if best_walkouts.has(str(current_level)) else lost
    return maxf(0.0, overall_review_stars() - float(effective - recorded) / 3.0) if running else overall_review_stars()

func review_text() -> String:
    return "%.2f / 5 STARS" % overall_review_stars()

func milestone_review_ready() -> bool:
    return overall_review_stars() >= 4.0

# Local, device-only statistics for achievements. No server or purchases are connected.
var total_pizzas_served: int = 0
var total_guests_served: int = 0
var total_perfect_days: int = 0
var total_completed_days: int = 0
var showcase_panel: PanelContainer
var showcase_body: VBoxContainer
var showcase_title: Label
var showcase_from_stage: bool = true
var trophy_button: Button
var leaderboard_button: Button
var coin_button: Button
var demo_shop_message: Label

var progress_count: int = 0
var clean_count: int = 0
var big_parties: int = 0
var vip_count: int = 0
var correct_count: int = 0
var wrong_count: int = 0
var delivery_count: int = 0
var delivery_ready: float = 0.0
var deliveries_spawned: int = 0
var birthday_id: int = -1
var birthday_seated: bool = false
var birthday_served: bool = false
var vip_served_final: bool = false
var reservation_spawned: bool = false
var dirty_max: int = 0
var selected_recipe: int = -1
var selected_toppings: Array[int] = []
var chef_overlay: PanelContainer
var chef_caption: Label
var chef_choice_buttons: Array[Button] = []
var chef_pending_tables: Array[int] = []
var chef_active_table: int = -1
var chef_selected: Array[int] = []
var chef_saved_selections: Dictionary = {}
const CHEF_NAMES := ["CHEESE", "PEPPERONI", "MUSHROOMS", "PEPPERS", "OLIVES", "BASIL"]
var lifetime_coins: int = 0
var upgrade_step: int = 0
# Each table is converted separately, permanently, and only by choice.
# Keep the historic 'chairs' save key for Table 7 backwards compatibility.
const STORE_ITEMS := [
    {"id":"chairs_6", "name":"Convert Table 6 to RED (4 seats)", "cost":150, "level":3, "details":"Upgrade yellow Table 6 from 2 to 4 seats.", "active":true},
    {"id":"chairs", "name":"Convert Table 7 to RED (4 seats)", "cost":150, "level":3, "details":"Upgrade yellow Table 7 from 2 to 4 seats.", "active":true},
    {"id":"chairs_8", "name":"Convert Table 8 to RED (4 seats)", "cost":150, "level":3, "details":"Upgrade yellow Table 8 from 2 to 4 seats.", "active":true},
    {"id":"expand4", "name":"Expansion: Fourth Yellow Table", "cost":350, "level":6, "details":"Grow from 3 to 4 tables. New tables begin yellow (2 seats).", "active":true},
    {"id":"chairs_4", "name":"Convert Table 4 to RED (4 seats)", "cost":150, "level":6, "details":"Requires the fourth-table expansion; adds two seats.", "active":true},
    {"id":"chairs_3", "name":"Convert Table 3 to RED (4 seats)", "cost":150, "level":11, "details":"Requires the fifth-table expansion; adds two seats.", "active":true},
    {"id":"chairs_5", "name":"Convert Table 5 to RED (4 seats)", "cost":150, "level":16, "details":"Requires the sixth-table expansion; adds two seats.", "active":true},
    {"id":"expand5", "name":"Expansion: Fifth Table", "cost":500, "level":11, "details":"Add exactly ONE table: grow from four to five tables.", "active":true},
    {"id":"expand6", "name":"Expansion: Sixth Table", "cost":650, "level":16, "details":"Add exactly ONE table: grow from five to six tables.", "active":true},
    {"id":"tray", "name":"Four-Pizza Serving Tray", "cost":450, "level":13, "details":"Optional: carry up to 4 pizzas at once; fixed one-time price, never empties your whole wallet.", "active":true},
    {"id":"cart3", "name":"Small Dish Cart (3)", "cost":400, "level":15, "details":"Collect up to three dirty dish pickups before washing.", "active":true},
    {"id":"cart4", "name":"Large Dish Cart (4)", "cost":450, "level":20, "details":"Collect up to four dirty dish pickups. Requires Small Dish Cart.", "active":true},
    {"id":"oven", "name":"Turbo Oven", "cost":600, "level":15, "details":"Cook any pizza in 3 seconds (standard oven 5s, with level modifiers).", "active":true},
    {"id":"robot", "name":"Robot Waiter", "cost":2300, "level":16, "details":"Automatically picks up and serves ready pizzas. Does not select toppings.", "active":true},
    {"id":"robot_speed", "name":"Robot Speed Upgrade", "cost":850, "level":18, "details":"Robot moves 30% faster. Requires Robot Waiter.", "active":true},
    {"id":"robot_capacity", "name":"Robot Capacity Upgrade", "cost":1100, "level":20, "details":"Robot collects up to two ready pizzas in one trip. Requires Robot Waiter.", "active":true},
    {"id":"delivery_auto", "name":"Delivery Assistant", "cost":1600, "level":20, "details":"Future: automatically handles delivery pickup orders.", "active":false},
    {"id":"restaurant2", "name":"Restaurant #2", "cost":2600, "level":11, "details":"Future: second restaurant location.", "active":false}
]
var robot_pos: Vector2 = Vector2(1120, 352)
var robot_targets: Array[int] = []
var robot_target_index: int = 0
var robot_busy: bool = false
var robot_pickup_delay: float = 0.0
var wallet_coins: int = 0
var owned_upgrades: Dictionary = {}
var shop_open: bool = false
var shop_button: Button
var shop_panel: Control
var shop_title: Label
var shop_rows: VBoxContainer
var shop_feedback: Label
var shop_return_to_menu: bool = false
func dish_cart_capacity() -> int:
    return 4 if has_upgrade("cart4") else (3 if has_upgrade("cart3") else 2)

func table_needs_second_pizza(table_id: int) -> bool:
    return int(tables[table_id]["party"].get("pizzas_left", 1)) > 1

func has_double_pizza_order() -> bool:
    return current_level >= 6

func has_double_dishes() -> bool:
    return current_level >= 12

func has_upgrade(id: String) -> bool:
    return bool(owned_upgrades.get(id, false))

func conversion_table_number(item_id: String) -> int:
    # Preserve the earlier Table 7 purchase key in existing save files.
    if item_id == "chairs": return 7
    if item_id.begins_with("chairs_"): return int(item_id.trim_prefix("chairs_"))
    return -1

func table_conversion_available(item_id: String) -> bool:
    var number: int = conversion_table_number(item_id)
    if number < 0: return true
    if not endless_mode and current_level < 2: return false
    var position: int = TABLE_NUMBERS.find(number)
    return position >= 0 and position < seating_table_count()

func has_red_table() -> bool:
    for t in tables:
        if int(t.get("seats", 2)) == 4: return true
    return false

func seating_table_count() -> int:
    # Purchased expansion persists on ALL days, including earlier-level replays.
    # Level progression still controls when each expansion becomes purchasable.
    var owned_count: int = 6 if has_upgrade("expand6") else (5 if has_upgrade("expand5") else (4 if has_upgrade("expand4") else 3))
    return owned_count

# Day 6/11/16 require buying the matching TABLE expansion, not only chairs.
func required_table_upgrade() -> String:
    if current_level >= 12 and not has_upgrade("tray"): return ""
    if current_level >= 15: return "expand6"
    if current_level >= 10: return "expand5"
    if current_level >= 5: return "expand4"
    return ""

func required_table_count() -> int:
    if current_level >= 15: return 6
    if current_level >= 10: return 5
    if current_level >= 5: return 4
    return 3

func expansion_gate_message() -> String:
    # Expansions are optional strategy upgrades, never progression blockers.
    return ""
    var upgrade: String = required_table_upgrade()
    if upgrade == "" or has_upgrade(upgrade): return ""
    var price: int = 0
    for item in STORE_ITEMS:
        if str(item["id"]) == upgrade:
            price = int(item["cost"])
            break
    if upgrade == "tray": return "DAY 13 REQUIRES THE SERVING TRAY. Purchase it in STORE; it spends your full wallet. Replay previous days if needed."
    return "DAY %d NEEDS %d TABLES. Buy the restaurant TABLE EXPANSION in STORE (%d coins). Wallet: %d; short: %d. Extra Chairs does not add a table. Replay earlier days to earn coins." % [current_level + 1, required_table_count(), price, wallet_coins, maxi(0, price-wallet_coins)]

func try_start_game() -> void:
    var warning: String = expansion_gate_message()
    if warning != "":
        if stage_panel != null: stage_panel.hide()
        if showcase_panel != null: showcase_panel.hide()
        show_level_brief()
        panel_description.text = warning + "\n\n" + panel_description.text
        start_button.text = "EXPANSION REQUIRED — OPEN STORE"
        start_button.disabled = true
        shop_button.show()
        if not shop_open:
            toggle_shop()
        shop_feedback.text = warning
        playtest_record("expansion_shop_redirect", {"day": current_level + 1, "wallet": wallet_coins, "required_upgrade": required_table_upgrade()})
        message = warning
        update_ui()
        return
    start_game()

func seating_goal_text() -> String:
    var red_count: int = 0
    for table in tables:
        if int(table.get("seats", 2)) == 4: red_count += 1
    return "SEATING: %d RED (4) + %d YELLOW (2) | Table conversion: 150 coins each from Day 3" % [red_count, maxi(0, tables.size() - red_count)]

func next_store_goal() -> Dictionary:
    # Prioritize immediately available table conversions, then expansions.
    for item in STORE_ITEMS:
        var item_id: String = str(item["id"])
        if conversion_table_number(item_id) >= 0 and not has_upgrade(item_id) and table_conversion_available(item_id):
            return item
    for item in STORE_ITEMS:
        if str(item["id"]).begins_with("expand") and not has_upgrade(str(item["id"])):
            return item
    for item in STORE_ITEMS:
        if bool(item["active"]) and not has_upgrade(str(item["id"])):
            return item
    return {}
func shop_goal_text() -> String:
    var item: Dictionary = next_store_goal()
    if item.is_empty(): return "CORE UPGRADES PURCHASED - MORE COMING SOON"
    return "NEXT UPGRADE: %s  |  WALLET %d/%d" % [str(item["name"]), wallet_coins, int(item["cost"])]
func affordable_upgrade_count() -> int:
    var count: int = 0
    for item in STORE_ITEMS:
        var id: String = str(item["id"])
        if not bool(item["active"]) or has_upgrade(id) or current_level + 1 < int(item["level"]) or wallet_coins < int(item["cost"]) or not table_conversion_available(id):
            continue
        if (id == "expand5" and not has_upgrade("expand4")) or (id == "expand6" and not has_upgrade("expand5")) or (id == "cart4" and not has_upgrade("cart3")) or (id.begins_with("robot_") and not has_upgrade("robot")):
            continue
        count += 1
    return count

func offer_affordable_upgrades() -> void:
    # Open only between shifts; never interrupt an active restaurant day.
    if running or shop_panel == null:
        return
    var options: int = affordable_upgrade_count()
    if options <= 0:
        return
    if not shop_open:
        toggle_shop()
    shop_feedback.text = "You can afford %d upgrade(s)! Choose what to buy, or close the store to continue." % options
    playtest_record("shop_auto_opened", {"affordable_options":options, "wallet":wallet_coins, "day":current_level + 1})

# The 3-card view groups all table conversions into one recurring "Chairs +"
# product, so buying it repeatedly converts the next yellow table.
func shop_card_data(entry: String) -> Dictionary:
    var entry_id: String = entry
    var short_name: String = ""
    var short_details: String = ""
    var icon_name: String = "chair-upgrade.png"
    if entry == "chairs_group":
        entry_id = ""
        var candidates := ["chairs_6", "chairs", "chairs_8", "chairs_4", "chairs_3", "chairs_5"]
        # Prefer a conversion possible today; do not hide later expansions.
        for key in candidates:
            if has_upgrade(key): continue
            var eligible := false
            for item in STORE_ITEMS:
                if str(item["id"]) == key:
                    eligible = (current_level + 1 >= int(item["level"]) and table_conversion_available(key))
                    break
            if eligible:
                entry_id = key
                break
        if entry_id == "":
            for key in candidates:
                if not has_upgrade(key):
                    entry_id = key
                    break
        if entry_id == "":
            return {"id":"", "name":"Chairs +", "details":"All six tables have been converted.", "cost":0, "icon":"chair-upgrade.png", "can_buy":false, "status":"ALL RED"}
        short_name = "Chairs +"
        short_details = "Add 2 chairs to Table %d" % conversion_table_number(entry_id)
    for item in STORE_ITEMS:
        if str(item["id"]) != entry_id: continue
        var price: int = int(item["cost"])
        var bought: bool = has_upgrade(entry_id)
        var allowed_level: bool = current_level + 1 >= int(item["level"])
        var active: bool = bool(item["active"])
        var prereq: bool = (entry_id == "expand5" and not has_upgrade("expand4")) or (entry_id == "expand6" and not has_upgrade("expand5")) or (entry_id == "cart4" and not has_upgrade("cart3")) or (entry_id.begins_with("robot_") and not has_upgrade("robot")) or not table_conversion_available(entry_id)
        var available: bool = active and not bought and allowed_level and not prereq and wallet_coins >= price
        var notice: String = ""
        if bought: notice = "OWNED"
        elif not active: notice = "COMING SOON"
        elif not allowed_level: notice = "UNLOCK: LEVEL %d" % int(item["level"])
        elif prereq: notice = "REQUIRES PRIOR UPGRADE"
        elif wallet_coins < price: notice = "NEED %d MORE COINS" % (price-wallet_coins)
        var text_name: String = str(item["name"])
        var text_details: String = str(item["details"])
        match entry_id:
            "tray":
                text_name = "Carrying Tray"
                text_details = "Carry up to 4 pizzas at once"
                icon_name = "tray-upgrade.png"
            "cart3":
                text_name = "Dish Tray"
                text_details = "Carry up to 3 dirty dishes"
                icon_name = "dish-tray-upgrade.png"
            "cart4":
                text_name = "Dish Cart +"
                text_details = "Carry 4 dirty dish pickups"
                icon_name = "dish-tray-upgrade.png"
            "oven":
                text_name = "Turbo Oven"
                text_details = "Make pizzas cook faster"
                icon_name = "oven-upgrade.png"
            "robot":
                text_name = "Robot Waiter"
                text_details = "Deliver ready pizzas for you"
                icon_name = "robo-pizza-upgrade.png"
            "robot_speed", "robot_capacity":
                text_name = "Robot Speed" if entry_id == "robot_speed" else "Double Robot Carry"
                text_details = "Faster robot service" if entry_id == "robot_speed" else "Robot carries two pizzas"
                icon_name = "multi-robot-upgrade.png"
            "delivery_auto":
                text_name = "Delivery Assistant"
                text_details = "Future delivery upgrade"
                icon_name = "multi-robot-upgrade.png"
            "restaurant2":
                text_name = "Second Restaurant"
                text_details = "Future second location"
                icon_name = "chair-upgrade.png"
            "expand4", "expand5", "expand6":
                text_name = "New Table Expansion"
                text_details = "Add table #%d to restaurant" % (4 if entry_id == "expand4" else 5 if entry_id == "expand5" else 6)
                icon_name = "chair-upgrade.png"
        if short_name != "": text_name = short_name
        if short_details != "": text_details = short_details
        return {"id":entry_id,"name":text_name,"details":text_details,"cost":price,"icon":icon_name,"can_buy":available,"status":notice}
    return {"id":"", "name":"NOT AVAILABLE", "details":"", "cost":0,"can_buy":false,"status":""}

func refresh_store() -> void:
    if shop_panel != null: shop_panel.call("refresh")

func buy_store_item(id: String) -> void:
    for item in STORE_ITEMS:
        if str(item["id"]) != id: continue
        var cost: int = int(item["cost"])
        if not bool(item["active"]) or current_level + 1 < int(item["level"]) or has_upgrade(id) or wallet_coins < cost or not table_conversion_available(id): return
        if id == "expand5" and not has_upgrade("expand4"): return
        if id == "expand6" and not has_upgrade("expand5"): return
        if id == "cart4" and not has_upgrade("cart3"): return
        if id.begins_with("robot_") and not has_upgrade("robot"): return
        var wallet_before_purchase: int = wallet_coins
        wallet_coins -= cost
        playtest_record("upgrade_purchased", {"upgrade":id, "price":cost, "balance_after":wallet_coins})
        owned_upgrades[id] = true
        if id.begins_with("expand") or conversion_table_number(id) >= 0:
            # The store is only available between shifts; rebuild without losing guests.
            prepare_scene()
        if id.begins_with("expand"):
            shop_feedback.text = "BOUGHT: %s | %d - %d = %d coins. Now %d tables!" % [str(item["name"]), wallet_before_purchase, cost, wallet_coins, seating_table_count()]
        elif conversion_table_number(id) >= 0:
            shop_feedback.text = "TABLE %d CONVERTED TO RED (4 SEATS)! %d coins left." % [conversion_table_number(id), wallet_coins]
        else:
            shop_feedback.text = "%s bought! %d - %d = %d coins remaining." % [str(item["name"]), wallet_before_purchase, cost, wallet_coins]
        _save_progress()
        # Stay in Shop after purchase; guests are not interrupted or auto-advanced.
        # Multiple yellow-to-red purchases work during one shop visit.
        refresh_store()
        update_ui()
        queue_redraw()
        return
func toggle_shop() -> void:
    # Shopping is only allowed from the pre-level briefing or results screen.
    if running: return
    shop_open = not shop_open
    shop_panel.visible = shop_open
    if shop_open:
        # Hide all other illustrated panels while the Shop is open.
        # Restore the appropriate screen when closing the Shop.
        if campaign_screens != null:
            campaign_screens.hide_screens()
        if start_panel != null: start_panel.hide()
        if stage_panel != null: stage_panel.hide()
        shop_panel.z_index = 850
        shop_panel.move_to_front()
        refresh_store()
    elif shop_return_to_menu:
        shop_return_to_menu = false
        show_main_menu()
    else:
        # Shop opened from the level briefing: return there when closed.
        show_level_brief()

# Alpha 12.45: contextual first-day teaching and upgrade purchase confirmation.
var tutorial_dialog: AcceptDialog
var tutorial_step: int = -1
var tutorial_waiting: bool = false
var tutorial_seen: bool = false
var purchase_dialog: ConfirmationDialog
var pending_purchase_id: String = ""
# Alpha 12.48: event-driven, non-modal visual teaching. No reading required.
const TUTORIAL_CUES := ["TAP GUESTS", "TAP A TABLE", "TAKE ORDER", "SEND ORDER", "WAIT FOR PIZZA", "PICK UP", "SERVE TABLE", "COLLECT COINS", "PICK UP DISHES", "WASH DISHES"]
var tutorial_anim_time: float = 0.0
var tutorial_skip_button: Button
var tutorial_target_table: int = -1

func create_tutorial_ui() -> void:
    tutorial_skip_button = Button.new()
    tutorial_skip_button.text = "SKIP GUIDE"
    tutorial_skip_button.position = Vector2(1080, 90)
    tutorial_skip_button.size = Vector2(170, 46)
    tutorial_skip_button.pressed.connect(_tutorial_skip)
    tutorial_skip_button.hide()
    root_ui.add_child(tutorial_skip_button)
    purchase_dialog = ConfirmationDialog.new()
    purchase_dialog.title = "CONFIRM YOUR UPGRADE"
    purchase_dialog.min_size = Vector2i(510, 250)
    purchase_dialog.ok_button_text = "BUY UPGRADE"
    purchase_dialog.confirmed.connect(_purchase_confirmed)
    root_ui.add_child(purchase_dialog)

func show_tutorial_step() -> void:
    if current_level != 0 or tutorial_seen or tutorial_step < 0: return
    tutorial_waiting = false
    tutorial_skip_button.show()
    playtest_record("visual_tutorial_step", {"step":tutorial_step, "cue":TUTORIAL_CUES[tutorial_step]})

func _tutorial_continue() -> void:
    pass

func _tutorial_skip() -> void:
    tutorial_seen = true
    tutorial_waiting = false
    tutorial_step = -1
    tutorial_skip_button.hide()
    playtest_record("tutorial_skipped", {})
    _save_progress()

func tutorial_advance(completed_step: int) -> void:
    if current_level != 0 or tutorial_seen or tutorial_step != completed_step - 1: return
    if completed_step >= TUTORIAL_CUES.size():
        _tutorial_finish()
        return
    tutorial_step = completed_step
    show_tutorial_step()

func _tutorial_finish() -> void:
    tutorial_seen = true
    tutorial_step = -1
    tutorial_waiting = false
    tutorial_skip_button.hide()
    message = "GREAT JOB! Keep serving your guests!"
    playtest_record("tutorial_finished", {})
    _save_progress()

func tutorial_cue_position() -> Vector2:
    match tutorial_step:
        0:
            return Vector2(105, 185)
        1:
            for i in range(tables.size()):
                if str(tables[i]["state"]) == "empty" and selected_party >= 0 and selected_party < queue.size() and int(tables[i]["seats"]) >= int(queue[selected_party]["size"]):
                    return TABLE_POS[i]
            return TABLE_POS[0]
        2, 6, 7, 8:
            var desired: String = {2:"order",6:"collected",7:"pay",8:"dirty"}[tutorial_step]
            for i in range(tables.size()):
                if str(tables[i]["state"]) == desired or (tutorial_step == 2 and str(tables[i]["state"]) == "deciding"):
                    return TABLE_POS[i]
            return TABLE_POS[0]
        3: return Vector2(1135, 414)
        4, 5: return Vector2(1135, 340)
        9: return Vector2(1135, 480)
    return Vector2(105, 185)

func draw_tutorial_cue() -> void:
    if not running or current_level != 0 or tutorial_seen or tutorial_step < 0: return
    var pos: Vector2 = tutorial_cue_position()
    var wiggle: float = sin(tutorial_anim_time * 14.0) * 7.0
    var pulse: float = (sin(tutorial_anim_time * 5.0) + 1.0) * 0.5
    var cue_pos: Vector2 = pos + Vector2(wiggle, 0)
    draw_arc(cue_pos, 67.0 + pulse * 12.0, 0.0, TAU, 48, Color(1.0, 0.78, 0.14, 0.9), 6.0, true)
    draw_arc(cue_pos, 79.0 + pulse * 9.0, 0.0, TAU, 48, Color(1.0, 0.95, 0.45, 0.35 + pulse * 0.4), 3.0, true)
    var hand_pos: Vector2 = pos + Vector2(45 + wiggle, -55 + sin(tutorial_anim_time * 7.0) * 7.0)
    draw_circle(hand_pos, 19.0, Color("fff1ba"))
    word("TAP", hand_pos + Vector2(0, 5), 13, Color("9a4c1d"))
    var cue: String = TUTORIAL_CUES[tutorial_step]
    var label_pos: Vector2 = Vector2(clampf(pos.x - 110.0, 12.0, 1045.0), clampf(pos.y - 120.0, 96.0, 575.0))
    draw_rect(Rect2(label_pos, Vector2(220, 37)), Color(0.27, 0.14, 0.09, 0.93))
    word(cue, label_pos + Vector2(110, 26), 19, Color("ffe08a"))

func confirm_store_purchase(id: String) -> void:
    for item in STORE_ITEMS:
        if str(item["id"]) != id: continue
        pending_purchase_id = id
        var price: int = int(item["cost"])
        var description: String = str(item["details"])
        purchase_dialog.dialog_text = "%s\n\n%s\n\nPrice: %d coins\nWallet now: %d coins\nWallet after: %d coins\n\nConfirm purchase?" % [str(item["name"]), description, price, wallet_coins, wallet_coins - price]
        purchase_dialog.popup_centered()
        return

func _purchase_confirmed() -> void:
    if pending_purchase_id != "":
        buy_store_item(pending_purchase_id)
    pending_purchase_id = ""

func create_shop_ui() -> void:
    # One reusable Shop panel for Main Menu, pre-level, and result screens.
    # Existing coin and upgrade dictionaries continue to own all purchases.
    shop_panel = load("res://scripts/shop_screen.gd").new()
    root_ui.add_child(shop_panel)
    shop_panel.call("setup",self)
    shop_feedback = shop_panel.get("feedback") as Label
    shop_panel.hide()
    var extras_row := HBoxContainer.new()
    var briefing_content: VBoxContainer = start_panel.get_child(0) as VBoxContainer
    shop_button = Button.new()
    shop_button.text = "SHOP / UPGRADES"
    shop_button.pressed.connect(toggle_shop)
    shop_button.custom_minimum_size = Vector2(0,40)
    briefing_content.add_child(shop_button)
    briefing_content.move_child(shop_button,2)
    for spec in [["TROPHIES","trophies"],["BEST SCORES","leaderboard"],["COINS","coins"]]:
        var b := Button.new()
        b.text = spec[0]
        b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
        b.pressed.connect(open_showcase.bind(spec[1]))
        extras_row.add_child(b)
    briefing_content.add_child(extras_row)
    var replay_tutorial := Button.new()
    replay_tutorial.text = "REPLAY LEVEL 1 TUTORIAL (on next Level 1 start)"
    replay_tutorial.pressed.connect(func(): tutorial_seen = false; _save_progress())
    briefing_content.add_child(replay_tutorial)

const PIZZA_TYPES := ["CHEESE", "PEPPERONI", "MUSHROOM"]
const INGREDIENT_NAMES := ["CHEESE", "PEPPERONI", "MUSHROOM", "PEPPERS"]
func mode() -> String:
    return str(cfg("kind"))
func needs_accuracy() -> bool:
    return mode() in ["correct", "ingredients", "final"]
func goal_status() -> String:
    match mode():
        "large": return "%d/%d large parties seated" % [big_parties, int(cfg("target"))]
        "clean": return "%d/%d cleaned | most dirty: %d/3" % [clean_count, int(cfg("target")), dirty_max]
        "vip": return "%d/%d VIP parties served" % [vip_count, int(cfg("target"))]
        "correct", "ingredients": return "%d/%d correct | %d wrong" % [correct_count, int(cfg("target")), wrong_count]
        "reservation": return "Birthday party: %s" % ("SERVED" if birthday_served else "SEATED" if birthday_seated else "NOT YET")
        "final": return "%d/4 correct | VIP:%s | PARTY:%s" % [correct_count, "Y" if vip_served_final else "N", "Y" if birthday_served else "N"]
        _: return "%d/%d guests served" % [served, int(cfg("target"))]
func goals_met() -> bool:
    match mode():
        "large": return big_parties >= int(cfg("target"))
        "clean": return clean_count >= int(cfg("target")) and dirty_max <= 3
        "vip": return vip_count >= int(cfg("target"))
        "correct": return correct_count >= int(cfg("target")) and wrong_count <= 1
        "ingredients": return correct_count >= int(cfg("target"))
        "reservation": return birthday_served
        "final": return correct_count >= 4 and vip_served_final and birthday_served and wrong_count <= 1
        _: return served >= int(cfg("target"))
func milestone_text() -> String:
    return seating_goal_text() + "  |  REVIEW: %s  |  Lifetime earned: %d" % [review_text(), lifetime_coins]
func expert_cash_goal() -> int:
    return int(cfg("goal")) + 35

func earned_stars(success: bool) -> int:
    if not success: return 0
    var count: int = 1
    if lost <= 2: count += 1
    if cash >= expert_cash_goal(): count += 1
    return count

func show_level_brief() -> void:
    panel_title.text = ("ENDLESS • ROUND %d" % endless_wave) if endless_mode else (("🔥 PIZZA RUSH DAY! • DAY %d" if is_rush_day() else "READY, CHEF?  •  DAY %d") % (current_level + 1))
    panel_description.text = "%s\n\nSAVED COINS: %d  |  EARN MORE BY COMPLETING DAYS\nGOAL: $%d     EXPERT: $%d\nSPECIAL MISSION: %s\n\n%s\n\nSCHEDULED PARTIES: %d  |  ARRIVAL WINDOW: %ds (finish serving after closing)\n1 star: finish mission + goal  •  2: ≤2 walkouts  •  3: expert cash\n\n%s" % [str(cfg("name")), wallet_coins, int(cfg("goal")), expert_cash_goal(), str(cfg("challenge")), str(cfg("brief")), int(cfg("party_cap")), int(cfg("time")), milestone_text()]
    if is_rush_day():
        panel_description.text = "🔥 PIZZA RUSH DAY! Customers have 20% LESS waiting time today. Serve carefully for up to 20 extra coins.\n\n" + panel_description.text
    if not endless_mode and current_level >= 2:
        var red_count: int = 0
        for table in tables:
            if int(table.get("seats", 2)) == 4: red_count += 1
        if red_count == 0:
            panel_description.text += "\n\nALL TABLES YELLOW (2 SEATS). Buy a RED TABLE conversion in STORE (150 coins) to welcome parties of 3 or 4. Until then, only parties of 1-2 arrive."
        else:
            panel_description.text += "\n\n%d RED TABLE(S) READY. Additional yellow-to-red conversions cost 150 coins each. Open STORE between shifts." % red_count
    start_button.show()
    start_button.text = "START ROUND %d  •  %d TABLES" % [endless_wave, seating_table_count()] if endless_mode else "START LEVEL %d  •  %d TABLES" % [current_level + 1, seating_table_count()]
    start_button.disabled = expansion_gate_message() != ""
    if start_button.disabled:
        panel_description.text = expansion_gate_message() + "\n\n" + panel_description.text
        start_button.text = "EXPANSION REQUIRED — OPEN STORE"
    retry_button.hide()
    shop_button.show()
    start_panel.show()
    if stage_select_button != null: stage_select_button.show()
    if campaign_screens != null:
        campaign_screens.show_pre()
        start_panel.hide()
func remaining_parties_to_arrive() -> int:
    # Special birthday party is one of the level's fixed total, not an extra party.
    return maxi(0, int(cfg("party_cap")) - next_party_id)

func active_parties() -> int:
    var n: int = queue.size()
    for t in tables:
        var p: Dictionary = t["party"]
        if not p.is_empty(): n += 1
    return n

func check_finish() -> void:
    if not running: return
    # Never stop a level merely because the minimum cash goal was reached.
    # Let every scheduled guest eat, pay or leave first.
    if remaining <= 0.0 and remaining_parties_to_arrive() == 0 and active_parties() == 0:
        var cleaning_done: bool = pending_cleaning.is_empty() and not tables.any(func(t: Dictionary) -> bool: return t["state"] in ["dirty", "dishes_collected"] or int(t.get("clean_left", 0)) > 0 and t["state"] != "empty")
        if not cleaning_done:
            message = "CLEAN ALL DISHES to finish the day! Collect every set and use DISHWASHING STATION."
        if cleaning_done:
            # Passing the revenue goal unlocks the next day. Special missions award
            # mastery/replay goals, but must never trap players on a completed day.
            end_game(cash >= int(cfg("goal")))

func is_rush_day() -> bool:
    return (endless_wave % 5 == 0) if endless_mode else ((current_level + 1) % 5 == 0)

func effective_patience_decay(base_decay: float) -> float:
    return base_decay * (1.25 if is_rush_day() else 1.0)

# Starting queue clock: 80 seconds normally, 70 on every fifth (Rush) day.
func starting_queue_patience() -> float:
    var queue_rate: float = maxf(0.01, effective_patience_decay(float(cfg("queue_decay"))) * (0.75 if has_upgrade("entertainer") else 1.0))
    return (110.0 if current_level == 11 else (70.0 if is_rush_day() else 80.0)) * queue_rate

func cfg(key: String) -> Variant:
    if endless_mode:
        return endless_cfg.get(key, LEVELS[current_level].get(key))
    return LEVELS[current_level][key]
func _load_progress() -> void:
    var file := ConfigFile.new()
    if file.load("user://pizza_panic_alpha12_47_level1_reset.cfg") == OK:
        highest_unlocked = clampi(int(file.get_value("campaign", "highest_unlocked", 0)), 0, LEVELS.size() - 1)
        lifetime_coins = int(file.get_value("campaign", "lifetime_coins", 0))
        wallet_coins = int(file.get_value("campaign", "wallet_coins", lifetime_coins))
        owned_upgrades = file.get_value("campaign", "owned_upgrades", {})
        best_stars = file.get_value("campaign", "best_stars", {})
        best_cash = file.get_value("campaign", "best_cash", {})
        best_walkouts = file.get_value("campaign", "best_walkouts", {})
        best_level_payout = file.get_value("campaign", "best_level_payout", {})
        # Older saves may contain best_cash but no replay payout history.
        # Treat an older personal best as already paid to avoid repeat farming.
        for key in best_cash.keys():
            if not best_level_payout.has(key):
                best_level_payout[key] = int(best_cash[key])
            if not best_walkouts.has(key):
                best_walkouts[key] = 0
        total_pizzas_served = int(file.get_value("campaign", "total_pizzas_served", 0))
        total_guests_served = int(file.get_value("campaign", "total_guests_served", 0))
        total_perfect_days = int(file.get_value("campaign", "total_perfect_days", 0))
        total_completed_days = int(file.get_value("campaign", "total_completed_days", 0))
        pizza_toss_reward_claimed = bool(file.get_value("campaign", "pizza_toss_reward_claimed", false))
        tutorial_seen = bool(file.get_value("campaign", "tutorial_seen", false))
        endless_best_wave = int(file.get_value("endless", "best_wave", 0))
        endless_best_cash = int(file.get_value("endless", "best_cash", 0))
        endless_record_payout = file.get_value("endless", "record_payout", {})
func _save_progress() -> void:
    var file := ConfigFile.new()
    file.set_value("campaign", "highest_unlocked", highest_unlocked)
    file.set_value("campaign", "lifetime_coins", lifetime_coins)
    file.set_value("campaign", "wallet_coins", wallet_coins)
    file.set_value("campaign", "owned_upgrades", owned_upgrades)
    file.set_value("campaign", "best_stars", best_stars)
    file.set_value("campaign", "best_cash", best_cash)
    file.set_value("campaign", "best_walkouts", best_walkouts)
    file.set_value("campaign", "best_level_payout", best_level_payout)
    file.set_value("campaign", "total_pizzas_served", total_pizzas_served)
    file.set_value("campaign", "total_guests_served", total_guests_served)
    file.set_value("campaign", "total_perfect_days", total_perfect_days)
    file.set_value("campaign", "total_completed_days", total_completed_days)
    file.set_value("campaign", "pizza_toss_reward_claimed", pizza_toss_reward_claimed)
    file.set_value("campaign", "tutorial_seen", tutorial_seen)
    file.set_value("endless", "best_wave", endless_best_wave)
    file.set_value("endless", "best_cash", endless_best_cash)
    file.set_value("endless", "record_payout", endless_record_payout)
    file.save("user://pizza_panic_alpha12_47_level1_reset.cfg")
func open_level(index: int) -> void:
    hide_level_complete_ui()
    hide_level_failed_ui()
    endless_mode = false
    current_level = clampi(index, 0, LEVELS.size()-1)
    prepare_scene()
    show_level_brief()
    update_ui()
    queue_redraw()
func _credit_rewarded_coins() -> void:
    wallet_coins += 50
    _save_progress()
    message = "Ad reward +50 coins! Saved wallet: %d" % wallet_coins
    update_ui()
    queue_redraw()
func create_rewarded_ad_ui() -> void:
    if not ads_bridge.is_mobile(): return
    rewarded_ad_button = Button.new()
    rewarded_ad_button.text = "WATCH OPTIONAL AD: +50 COINS (MOBILE)"
    rewarded_ad_button.custom_minimum_size = Vector2(0, 44)
    rewarded_ad_button.pressed.connect(func() -> void:
        if not ads_bridge.request_rewarded():
            message = "Rewarded ad unavailable or cooldown active. Check again later (up to every 3 minutes)."
            update_ui()
    )
    var brief: VBoxContainer = start_panel.get_child(0) as VBoxContainer
    brief.add_child(rewarded_ad_button)
func _continue_after_ad() -> void:
    _start_next_day_now()
func _start_next_day_now() -> void:
    if campaign_win and current_level < LEVELS.size() - 1:
        current_level += 1
        highest_unlocked = maxi(highest_unlocked, current_level)
        _save_progress()
    if stage_panel != null: stage_panel.hide()
    if toss_launch_button != null: toss_launch_button.hide()
    if showcase_panel != null: showcase_panel.hide()
    if shop_open: toggle_shop()
    # Keep the existing ad/unlock logic, but show the next day's illustrated brief.
    open_level(current_level)
func next_level() -> void:
    if running: return
    if endless_mode:
        if campaign_win:
            endless_wave += 1
            _save_progress()
        open_endless_wave()
        return
    # No forced interstitial advertising between days.
    _start_next_day_now()

# Compact 4-by-2 dining grid. Kitchen remains in the right-hand service column.
# Gameplay indices map to fixed numbered floor positions. Never reorder these IDs for graphics.
const TABLE_NUMBERS := [6, 7, 8, 4, 3, 5, 1, 2]
var TABLE_POS: Array[Vector2] = [Vector2(349,580),Vector2(668,588),Vector2(963,580),Vector2(648,384),Vector2(385,384),Vector2(910,383),Vector2(420,228),Vector2(645,228)]
const SEATS := [2, 2, 2, 2, 2, 2, 2, 2]
const SHIRTS := [Color("4c99c4"), Color("e87866"), Color("99bd61"), Color("a985ca"), Color("e6af63"), Color("57b6a5")]
const FLOOR := Color("f5d1a3")
const BROWN := Color("75422d")
const DARK := Color("452b2b")

# Mapped art data is shipped WITH the project, not loaded from another machine's user:// folder.
const TABLE_LAYOUT_PATH := "res://data/graphics_layout.json"
const RESTAURANT_BG_PATH := "res://assets/replacements/backgrounds/game-play-screen.png"
var table_layout: Dictionary = {}
var table_sprite_cache: Dictionary = {}
var restaurant_background: Texture2D = null
var customer_one_poses: Array[Texture2D] = []
var pizza_eating_frames: Array = []

func load_mapped_table_art() -> void:
    if FileAccess.file_exists(TABLE_LAYOUT_PATH):
        var contents = JSON.parse_string(FileAccess.get_file_as_string(TABLE_LAYOUT_PATH))
        if contents is Array:
            for row in contents:
                if row is Dictionary and str(row.get("id", "")).begins_with("PP-TABLE-"):
                    var table_number: int = int(str(row["id"]).trim_prefix("PP-TABLE-"))
                    table_layout[table_number] = row
                    var game_index: int = TABLE_NUMBERS.find(table_number)
                    if game_index >= 0:
                        TABLE_POS[game_index] = Vector2(float(row.get("x", 0)), float(row.get("y", 0)))
    if ResourceLoader.exists(RESTAURANT_BG_PATH):
        restaurant_background = load(RESTAURANT_BG_PATH) as Texture2D
    for pose_id in range(1, 13):
        var pose_path: String = "res://assets/animations/customers/customer_01/pose_%02d.png" % pose_id
        if ResourceLoader.exists(pose_path):
            customer_one_poses.append(load(pose_path) as Texture2D)
    for pizza_file in ["chesse-pizza-sprite.png", "mushroom-pizza-sprite.png", "peperonii-pizza-sprite.png"]:
        var pizza_path: String = "res://assets/animations/pizza/" + pizza_file
        if ResourceLoader.exists(pizza_path):
            pizza_eating_frames.append(load(pizza_path) as Texture2D)

# All tables default to 2-seat yellow art; red is shown only after a conversion.
# Reuse the approved yellow 2-seat asset at locations without a unique variant.
const TABLE_7_TWO_SEAT_IMAGE := "res://assets/replacements/elements/table-7-yellow.png"
const TABLE_7_FOUR_SEAT_IMAGE := "res://assets/replacements/elements/red-7-table.png"

func table_sprite(number: int, seats: int) -> Texture2D:
    var path: String = TABLE_7_FOUR_SEAT_IMAGE if seats == 4 else TABLE_7_TWO_SEAT_IMAGE
    if not table_sprite_cache.has(path):
        table_sprite_cache[path] = load(path) as Texture2D if ResourceLoader.exists(path) else null
    return table_sprite_cache[path]

func draw_mapped_table(number: int, seats: int, locked: bool = false) -> bool:
    if not table_layout.has(number):
        return false
    var entry: Dictionary = table_layout[number]
    var center := Vector2(float(entry.get("x", 0)), float(entry.get("y", 0)))
    var dimensions := Vector2(float(entry.get("width", 124)), float(entry.get("height", 80))) * float(entry.get("scale", 1.0))
    var texture := table_sprite(number, seats)
    if texture == null:
        return false
    var native_size: Vector2 = texture.get_size()
    if native_size.x > 0.0 and native_size.y > 0.0:
        var fit: float = minf(dimensions.x / native_size.x, dimensions.y / native_size.y)
        dimensions = native_size * fit
    draw_texture_rect(texture, Rect2(center - dimensions / 2.0, dimensions), false)
    if locked:
        var overlay_path := "res://assets/replacements/elements/table-unlock.png"
        if not table_sprite_cache.has(overlay_path):
            table_sprite_cache[overlay_path] = load(overlay_path) as Texture2D if ResourceLoader.exists(overlay_path) else null
        var overlay: Texture2D = table_sprite_cache[overlay_path]
        if overlay != null:
            draw_texture_rect(overlay, Rect2(center - dimensions / 2.0, dimensions), false)
    return true

var tables: Array = []
var queue: Array = []
var selected_party := -1
var next_party_id := 0
var waitress_pos := Vector2(1040, 600)
var waitress_destination := Vector2(1040, 600)
var task_table := -1
var task_type := ""
var task_party_id := -1
# FIFO tap queue: players can plan several waitress stops while she is walking.
var action_queue: Array[Vector2] = []
const MAX_QUEUED_ACTIONS := 4
# Mobile OSes may synthesize a mouse click immediately after a screen touch.
var last_touch_ms: int = -10000
var last_touch_position: Vector2 = Vector2(-9999, -9999)
var held_tickets: Array[int] = []
var carried_pizzas: Array[int] = []
var station_task: String = ""
var pending_cleaning: Array[int] = []
var cleaning_kits: Array[int] = [] # legacy save-safe; no cleaning kits required
var elapsed := 0.0
var remaining: float = 150.0
var spawn_clock := 0.0
# Precomputed, irregular arrival times for ordinary parties this shift.
var party_arrival_times: Array[float] = []
var next_arrival_slot: int = 0
var hud_clock := 0.0
var cash := 0
var served := 0
var guests_arrived_this_shift: int = 0 # Level Complete denominator; updated only when parties are generated.
var lost := 0
var chain := 0
var running := false
var shift_paused: bool = false
var pause_button: TextureButton
var pause_overlay: PanelContainer
var chef_popup_hidden_for_pause: bool = false
var finished := false
var message := "Tap START to open your restaurant!"
var float_text: Array = []
var particles: Array = []
var root_ui: Control
var hud: Label
# Live values are displayed individually, inside the illustrated gameplay HUD.
var hud_counters: Dictionary = {}
const LILITA_FONT_PATH := "res://assets/fonts/LilitaOne-Regular.ttf"
var game_display_font: Font = null
var message_label: Label
var start_panel: PanelContainer
var start_button: Button
var retry_button: Button
# Alpha 12.77: illustrated level-complete results; drawn on top of the gameplay HUD.
var level_complete_screen: Control
var level_complete_stars: Array[TextureRect] = []
var level_complete_coin_value: Label
var level_complete_people_value: Label
var level_complete_next_button: TextureButton
# Alpha 12.78: dedicated results overlay for failed campaign levels.
var level_failed_screen: Control
var level_failed_coins_value: Label
var level_failed_guests_value: Label
var level_failed_replay_button: TextureButton
var level_failed_select_button_art: TextureButton
var campaign_screens
var pending_bonus_day_after_results: int = -1
var panel_title: Label
var panel_description: Label
var art: Texture2D
var rng := RandomNumberGenerator.new()

# Musical Rush: original accordion motifs with synchronized crossfade and timed events.
const SONG_PATHS := {
    "cafe":"res://audio/cafe.wav", "family":"res://audio/family.wav",
    "romance":"res://audio/romance.wav", "party":"res://audio/party.wav",
    "vip":"res://audio/vip.wav", "fever":"res://audio/fever.wav"
}
var music_players: Array[AudioStreamPlayer] = []
var current_song: String = ""
var pending_song: String = ""
var music_fade: float = 1.0
var music_active_player: int = 0
var music_muted: bool = true
var music_button: Button
var song_label: Label
var event_label: Label
var music_event: String = ""
var music_goal: int = 0
var music_progress: int = 0
var music_seconds: float = 0.0
var music_successes: int = 0
var last_song_before_event: String = "cafe"
var song_cache: Dictionary = {}

func initialize_music() -> void:
    for key in SONG_PATHS.keys():
        song_cache[key] = load(SONG_PATHS[key])
    for i in range(2):
        var player := AudioStreamPlayer.new()
        player.volume_db = -60.0
        player.bus = "Master"
        player.finished.connect(_music_finished.bind(i))
        add_child(player)
        music_players.append(player)
    song_label = Label.new()
    song_label.position = Vector2(1015, 641)
    song_label.size = Vector2(250, 24)
    song_label.add_theme_color_override("font_color", Color("ffe7b3"))
    song_label.add_theme_font_size_override("font_size", 12)
    song_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
    root_ui.add_child(song_label)
    event_label = Label.new()
    event_label.position = Vector2(224, 646)
    event_label.size = Vector2(773, 25)
    event_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
    event_label.add_theme_color_override("font_color", Color("fff1b3"))
    event_label.add_theme_font_size_override("font_size", 13)
    event_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
    root_ui.add_child(event_label)
    music_button = Button.new()
    music_button.position = Vector2(1122, 674)
    music_button.size = Vector2(141, 33)
    music_button.text = "Music OFF"
    music_button.pressed.connect(toggle_music)
    root_ui.add_child(music_button)
    change_song("cafe")

func _music_finished(index: int) -> void:
    if running and not music_muted and music_players[index].stream != null:
        music_players[index].play()

func toggle_music() -> void:
    music_muted = not music_muted
    music_button.text = "Music OFF" if music_muted else "Music ON"
    if music_muted:
        for p in music_players: p.stop()
    else:
        change_song(current_song if not current_song.is_empty() else "cafe", true)

func change_song(song: String, force: bool = false) -> void:
    if song == current_song and not force: return
    if not SONG_PATHS.has(song): return
    var alternate: int = 1 - music_active_player
    var new_player: AudioStreamPlayer = music_players[alternate]
    new_player.stream = song_cache[song]
    new_player.volume_db = -55.0
    if running and not music_muted: new_player.play()
    music_active_player = alternate
    current_song = song
    music_fade = 0.0
    if song_label != null: song_label.text = "MUSIC: " + song.to_upper()

func music_tick(dt: float) -> void:
    if music_fade < 1.0:
        music_fade = minf(1.0, music_fade + dt / 0.85)
    for i in range(music_players.size()):
        var p: AudioStreamPlayer = music_players[i]
        var loud: float = music_fade if i == music_active_player else 1.0 - music_fade
        p.volume_db = linear_to_db(maxf(0.001, loud * 0.27))
        if i != music_active_player and music_fade >= 1.0 and p.playing:
            p.stop()
    if music_event != "":
        music_seconds -= dt
        if music_seconds <= 0.0:
            music_seconds = 0.0
            message = "MUSIC CHALLENGE MISSED! Try the next special party."
            music_event = ""
            change_song("cafe")
    update_music_text()

func update_music_text() -> void:
    if event_label == null: return
    if music_event == "":
        event_label.text = ""
    else:
        event_label.text = "MUSIC BONUS: %s  %d/%d  |  %ds LEFT" % [music_event.to_upper(), music_progress, music_goal, int(ceilf(music_seconds))]

func launch_music_event(kind: String) -> void:
    # Music challenges belong to Stage 3 (Days 41+) and later, not early shifts.
    if current_level < 40: return
    if music_event != "": return
    music_event = kind
    music_progress = 0
    match kind:
        "family": music_goal = 2; music_seconds = 40.0
        "romance": music_goal = 2; music_seconds = 38.0
        "party": music_goal = 1; music_seconds = 55.0
        "vip": music_goal = 1; music_seconds = 44.0
        _: music_goal = 2; music_seconds = 40.0
    change_song(kind)
    message = "MUSIC EVENT! Serve %d %s group(s) before the song timer runs out!" % [music_goal,kind]
    update_music_text()

func music_on_payment(party: Dictionary) -> void:
    if current_level < 40 or music_event.is_empty(): return
    var matches: bool = false
    match music_event:
        "family": matches = int(party["size"]) >= 3
        "romance": matches = int(party["size"]) == 2
        "party": matches = party.has("birthday") and bool(party["birthday"])
        "vip": matches = bool(party["vip"])
    if not matches: return
    music_progress += 1
    if music_progress >= music_goal:
        cash += 75
        music_successes += 1
        add_float(Vector2(620, 132), "+$75 MUSIC BONUS!")
        music_event = ""
        change_song("fever")
        message = "MUSICAL RUSH COMPLETE! +$75 BONUS!"
    update_music_text()

func reset_music_state() -> void:
    music_event = ""
    music_seconds = 0.0
    music_progress = 0
    music_successes = 0
    change_song("cafe", true)
    update_music_text()



# Ingredient crafting begins on Day 11.  This is a modal input panel only:
# it deliberately does NOT pause _process(), arrivals, or the shift timer.
func create_chef_popup() -> void:
    chef_overlay = PanelContainer.new()
    chef_overlay.position = Vector2(316, 137)
    chef_overlay.custom_minimum_size = Vector2(660, 0)
    chef_overlay.size = Vector2(660, 410)
    chef_overlay.z_index = 95
    var layout := VBoxContainer.new()
    layout.add_theme_constant_override("separation", 10)
    chef_overlay.add_child(layout)
    chef_caption = Label.new()
    chef_caption.text = "CHEF'S PIZZA BUILDER"
    chef_caption.add_theme_font_size_override("font_size", 22)
    layout.add_child(chef_caption)
    var subtitle := Label.new()
    subtitle.text = "Choose the customer's toppings. The shift clock keeps running!"
    layout.add_child(subtitle)
    var choices := GridContainer.new()
    choices.columns = 3
    layout.add_child(choices)
    for k in range(CHEF_NAMES.size()):
        var option := Button.new()
        option.custom_minimum_size = Vector2(195, 56)
        option.text = CHEF_NAMES[k]
        option.pressed.connect(toggle_chef_ingredient.bind(k))
        choices.add_child(option)
        chef_choice_buttons.append(option)
    var commands := HBoxContainer.new()
    layout.add_child(commands)
    var cook := Button.new()
    cook.text = "COOK PIZZA"
    cook.custom_minimum_size = Vector2(255, 55)
    cook.pressed.connect(cook_chef_pizza)
    commands.add_child(cook)
    var later := Button.new()
    later.text = "CHECK ORDER AGAIN"
    later.custom_minimum_size = Vector2(245, 55)
    later.pressed.connect(close_chef_popup)
    commands.add_child(later)
    root_ui.add_child(chef_overlay)
    chef_overlay.hide()

func open_next_chef_ticket() -> void:
    # Only called from ticket submission, chef Cook, or explicit ORDER DISH tap.
    # Never auto-open an ingredient popup when a pizza is delivered.
    if shift_paused or not running or current_level < 5 or chef_overlay.visible or chef_pending_tables.is_empty(): return
    while not chef_pending_tables.is_empty():
        var id: int = chef_pending_tables.pop_front()
        if id < 0 or id >= tables.size() or str(tables[id]["state"]) != "chef_wait":
            chef_saved_selections.erase(id)
            continue
        if tables[id]["party"].is_empty():
            chef_saved_selections.erase(id)
            continue
        chef_active_table = id
        chef_selected.clear()
        for saved_ingredient in chef_saved_selections.get(id, []):
            chef_selected.append(int(saved_ingredient))
        var wanted: Array = tables[id]["party"].get("toppings", [])
        var requested: String = ""
        for ingredient in wanted:
            if not requested.is_empty(): requested += " + "
            requested += CHEF_NAMES[int(ingredient)]
        chef_caption.text = "TABLE %d  |  PIZZA %d OF %d  |  %s" % [id + 1, int(tables[id]["party"].get("pizzas_total", 1)) - int(tables[id]["party"].get("pizzas_left", 1)) + 1, int(tables[id]["party"].get("pizzas_total", 1)), requested]
        playtest_record("chef_ticket_opened", {"table":id+1, "pizzas_remaining":int(tables[id]["party"].get("pizzas_left", 1))})
        refresh_chef_choices()
        chef_overlay.show()
        return

func open_chef_ticket_for_table(table_id: int) -> void:
    # Direct ticket shortcut: selecting toppings is immediate, cooking still uses kitchen rules.
    if table_id < 0 or table_id >= tables.size() or str(tables[table_id]["state"]) != "chef_wait":
        return
    if chef_overlay != null and chef_overlay.visible:
        return
    chef_pending_tables.erase(table_id)
    chef_pending_tables.push_front(table_id)
    playtest_record("chef_ticket_table_shortcut", {"table": table_id + 1})
    open_next_chef_ticket()

func refresh_chef_choices() -> void:
    for k in range(chef_choice_buttons.size()):
        chef_choice_buttons[k].text = ("✓  " if k in chef_selected else "○  ") + CHEF_NAMES[k]
        chef_choice_buttons[k].disabled = k >= 3 and current_level < 13

func toggle_chef_ingredient(k: int) -> void:
    if current_level < 5: return
    if k >= 3 and current_level < 13: return
    if k in chef_selected:
        chef_selected.erase(k)
    else:
        var maximum: int = 1 if current_level < 10 else (2 if current_level < 15 else 3)
        if chef_selected.size() >= maximum:
            message = "This order allows %d topping(s). Remove one before adding another." % maximum
            return
        chef_selected.append(k)
    refresh_chef_choices()

func close_chef_popup() -> void:
    playtest_record("chef_check_order_again", {"table":chef_active_table+1, "ingredients":chef_selected.duplicate()})
    # Save this recipe in progress and put its ticket behind other waiting orders.
    var deferred_table: int = chef_active_table
    chef_overlay.hide()
    chef_active_table = -1
    if deferred_table >= 0 and deferred_table < tables.size() and str(tables[deferred_table]["state"]) == "chef_wait":
        chef_saved_selections[deferred_table] = chef_selected.duplicate()
        if deferred_table not in chef_pending_tables:
            chef_pending_tables.append(deferred_table)
    chef_selected.clear()
    # If other tables have orders, immediately show the next ticket instead.
    # Avoid instantly reopening the exact same deferred ticket.
    if chef_pending_tables.size() > 1:
        open_next_chef_ticket()
        message = "Order saved for Table %d. Reviewing next pizza ticket." % (deferred_table + 1)
    else:
        message = "Order saved. Tap ORDER DISH to check the order again."

func pizza_matches_order(ingredients: Array, wanted: Array) -> bool:
    if ingredients.size() != wanted.size():
        return false
    for ingredient in wanted:
        if ingredient not in ingredients:
            return false
    return true

# Raise the REMAINING patience by 25%, rather than restoring 25 points.
# A short-lived bonus may lift patience above the normal 100-point starting value.
func apply_quick_patience_bonus(party: Dictionary, table_id: int, reason: String) -> void:
    var before: float = maxf(0.0, float(party.get("patience", 0.0)))
    var after: float = minf(125.0, before * 1.25)
    party["patience"] = after
    party["patience_bar_max"] = maxf(100.0, after)
    add_float(TABLE_POS[table_id], "+25% FAST " + reason + "!")
    playtest_record("quick_patience_bonus", {"table":table_id + 1, "reason":reason, "before":before, "after":after})

func deliver_cooked_pizza(table_id: int, by_robot: bool = false) -> void:
    var table: Dictionary = tables[table_id]
    var cooked: Array = table.get("cooked_toppings", [])
    var wanted: Array = table["party"].get("toppings", [])
    # Days 1–5 have no custom ingredient stage.
    if current_level >= 5 and not wanted.is_empty() and not pizza_matches_order(cooked, wanted):
        wrong_count += 1
        playtest_record("wrong_pizza_rejected", {"table":table_id + 1, "wanted":wanted.duplicate(), "delivered":cooked.duplicate(), "by_robot":by_robot})
        chain = 0
        table["party"]["patience"] = maxf(12.0, float(table["party"]["patience"]) - 15.0)
        table["state"] = "chef_wait"
        table["timer"] = 0.0
        table["cooked_toppings"] = []
        table["recipe_verified"] = false
        chef_saved_selections.erase(table_id)
        if table_id not in chef_pending_tables:
            chef_pending_tables.append(table_id)
        add_float(TABLE_POS[table_id], "WRONG PIZZA! 😠")
        # The rejected pizza can serve a different table only if it matches its
        # exact submitted recipe and that order hasn't started cooking.
        var reassigned: int = -1
        for other_id in range(tables.size()):
            if other_id == table_id:
                continue
            if str(tables[other_id]["state"]) != "chef_wait":
                continue
            if bool(tables[other_id]["party"].get("custom_order", false)) and pizza_matches_order(cooked, tables[other_id]["party"].get("toppings", [])):
                reassigned = other_id
                break
        if reassigned >= 0:
            tables[reassigned]["cooked_toppings"] = cooked.duplicate()
            tables[reassigned]["recipe_verified"] = true
            tables[reassigned]["state"] = "ready"
            tables[reassigned]["timer"] = 0.0
            chef_pending_tables.erase(reassigned)
            chef_saved_selections.erase(reassigned)
            if chef_active_table == reassigned:
                chef_overlay.hide()
                chef_active_table = -1
                chef_selected.clear()
            add_float(TABLE_POS[reassigned], "PIZZA REUSED!")
            message = "Table %d rejected the wrong pizza! It matches Table %d's order and is ready at pickup. Remake Table %d's pizza." % [table_id + 1, reassigned + 1, table_id + 1]
        else:
            message = "Table %d rejected the wrong pizza and is upset. No other order matches; remake it at ORDER DISH!" % (table_id + 1)
        # A returned pizza queues a remake but does NOT interrupt delivery
        # with a new ingredient popup; revisit the ticket at ORDER DISH.
        return
    playtest_record("pizza_accepted", {"table":table_id + 1, "wanted":wanted.duplicate(), "delivered":cooked.duplicate(), "by_robot":by_robot})
    # Successful delivery completes this ticket permanently. Never allow a
    # stale/deferred chef ticket to reopen the ingredient selector for diners.
    while table_id in chef_pending_tables:
        chef_pending_tables.erase(table_id)
    chef_saved_selections.erase(table_id)
    if chef_active_table == table_id:
        chef_overlay.hide()
        chef_active_table = -1
        chef_selected.clear()
    var pizzas_left: int = int(table["party"].get("pizzas_left", 1))
    if pizzas_left > 1:
        table["party"]["pizzas_left"] = pizzas_left - 1
        # Keep the ticket on this same table. Its second pizza must be cooked,
        # picked up and delivered independently before anyone starts eating.
        if bool(table["party"].get("custom_order", false)):
            table["state"] = "chef_wait"
            if table_id not in chef_pending_tables:
                chef_pending_tables.append(table_id)
        else:
            table["state"] = "cooking"
            table["timer"] = 3.0 if has_upgrade("oven") else 5.0 * float(cfg("cook"))
            table["cooked_toppings"] = []
        add_float(TABLE_POS[table_id], "1 MORE PIZZA!")
        message = "Table %d received its first pizza. Prepare and deliver the second before the guests eat!" % (table_id + 1)
        return
    table["party"]["pizzas_left"] = 0
    # Bonus only for a correct FINAL pizza, delivered within three seconds
    # of that pizza becoming ready at the pickup bar; never award twice.
    var delivered_party: Dictionary = table["party"]
    if not bool(delivered_party.get("quick_delivery_bonus_used", false)) and elapsed - float(table.get("pizza_ready_at", -9999.0)) <= 3.0:
        delivered_party["quick_delivery_bonus_used"] = true
        apply_quick_patience_bonus(delivered_party, table_id, "DELIVERY")
    table["state"] = "eating"
    table["timer"] = 8.0
    if current_level >= 5:
        correct_count += 1
    add_float(TABLE_POS[table_id], "PIZZA SERVED!")
    burst(TABLE_POS[table_id])
    message = ("Robot delivered" if by_robot else "Waitress delivered") + " a correct pizza to Table %d!" % (table_id + 1)

func cook_chef_pizza() -> void:
    playtest_record("chef_cook_pressed", {"table":chef_active_table+1, "ingredients":chef_selected.duplicate()})
    var id: int = chef_active_table
    if id < 0 or id >= tables.size(): return
    if str(tables[id]["state"]) != "chef_wait": return
    var wanted: Array = tables[id]["party"].get("toppings", [])
    var correct: bool = chef_selected.size() == wanted.size()
    for n in wanted:
        if n not in chef_selected: correct = false
    # Allow imperfect pizzas to cook: customers judge the recipe on delivery.
    # A rejected pizza may still be reused for a matching waiting order.
    var cooked_recipe: Array = chef_selected.duplicate()
    # Ingredient selection NEVER seats, feeds, pays or clears a party.
    # This transitions ONLY from chef_wait to cooking.
    if str(tables[id]["state"]) != "chef_wait": return
    tables[id]["state"] = "cooking"
    tables[id]["timer"] = (3.0 if has_upgrade("oven") else 5.0 * float(cfg("cook")))
    tables[id]["recipe_verified"] = correct
    tables[id]["cooked_toppings"] = cooked_recipe
    chef_overlay.hide()
    chef_walk_remaining = CHEF_WALK_SECONDS
    chef_oven_in_remaining = CHEF_WALK_SECONDS + CHEF_OVEN_IN_SECONDS
    chef_active_table = -1
    chef_saved_selections.erase(id)
    chef_pending_tables.erase(id)
    chef_selected.clear()
    add_float(TABLE_POS[id], "PIZZA IN OVEN!")
    message = "Table %d's pizza is cooking. The customer will check the toppings at delivery." % (id + 1)
    open_next_chef_ticket()

var ads_bridge: Node
var rewarded_ad_button: Button

# Standalone bonus mini-game: never occurs during a restaurant shift.
var pizza_toss_reward_claimed: bool = false
var toss_active: bool = false
var toss_remaining: float = 0.0
var toss_phase: float = 0.0
var toss_score: int = 0
var toss_attempts: int = 0
var toss_panel: PanelContainer
var toss_title: Label
var toss_status: Label
var toss_action_button: Button
var toss_exit_button: Button
var toss_launch_button: Button

func create_competition_hub() -> void:
    competition_hub = load("res://scripts/competition_hub.gd").new()
    competition_hub.name = "CompetitionHub"
    root_ui.add_child(competition_hub)
    milestone_bonus_button = Button.new()
    milestone_bonus_button.name = "MilestoneBonusButton"
    milestone_bonus_button.text = "PLAY MINI-GAME"
    milestone_bonus_button.position = Vector2(400, 655)
    milestone_bonus_button.size = Vector2(490, 45)
    milestone_bonus_button.z_index = 130
    milestone_bonus_button.pressed.connect(func() -> void:
        competition_hub.open_game(current_level + 1)
    )
    root_ui.add_child(milestone_bonus_button)
    milestone_bonus_button.hide()

func create_pizza_toss_ui() -> void:
    toss_panel = PanelContainer.new()
    toss_panel.position = Vector2(350, 142)
    toss_panel.size = Vector2(580, 414)
    toss_panel.z_index = 350
    toss_panel.mouse_filter = Control.MOUSE_FILTER_STOP
    var layout := VBoxContainer.new()
    layout.add_theme_constant_override("separation", 20)
    toss_panel.add_child(layout)
    toss_title = Label.new()
    toss_title.text = "🍕 PIZZA TOSS — BONUS STAGE"
    toss_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    toss_title.add_theme_font_size_override("font_size", 27)
    layout.add_child(toss_title)
    var instructions := Label.new()
    instructions.text = "Tap TOSS when the moving marker is in the green center zone!\n20 seconds • aim for 8 accurate tosses.\nThis is NOT a restaurant shift."
    instructions.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    instructions.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    layout.add_child(instructions)
    toss_status = Label.new()
    toss_status.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    toss_status.add_theme_font_size_override("font_size", 22)
    layout.add_child(toss_status)
    toss_action_button = Button.new()
    toss_action_button.text = "🍕 TOSS PIZZA!"
    toss_action_button.custom_minimum_size = Vector2(0, 76)
    toss_action_button.pressed.connect(toss_pizza)
    layout.add_child(toss_action_button)
    toss_exit_button = Button.new()
    toss_exit_button.text = "CLOSE BONUS STAGE / BACK TO DAYS"
    toss_exit_button.custom_minimum_size = Vector2(0, 52)
    toss_exit_button.pressed.connect(close_pizza_toss)
    layout.add_child(toss_exit_button)
    root_ui.add_child(toss_panel)
    toss_panel.hide()
    toss_launch_button = Button.new()
    toss_launch_button.text = "🍕 PIZZA TOSS BONUS STAGE (AFTER DAY 20)"
    toss_launch_button.position = Vector2(400, 612)
    toss_launch_button.size = Vector2(490, 42)
    toss_launch_button.z_index = 110
    toss_launch_button.pressed.connect(open_pizza_toss)
    root_ui.add_child(toss_launch_button)
    toss_launch_button.hide()

func open_pizza_toss() -> void:
    if running or not milestone_review_ready() or int(best_stars.get("99", 0)) == 0:
        return
    if stage_panel != null: stage_panel.hide()
    start_panel.hide()
    toss_launch_button.hide()
    toss_active = true
    toss_score = 0
    toss_attempts = 0
    toss_phase = 0.0
    toss_remaining = 20.0
    toss_action_button.disabled = false
    toss_action_button.text = "🍕 TOSS PIZZA!"
    toss_panel.show()
    update_toss_labels()
    playtest_record("pizza_toss_started", {"reward_claimed_before":pizza_toss_reward_claimed})

func update_toss_labels() -> void:
    if toss_status == null: return
    var marker: float = sin(toss_phase)
    toss_status.text = "TIME %02ds   SCORE %d/8   TOSSES %d\n\nAIM: %s" % [ceili(toss_remaining), toss_score, toss_attempts, "🟢 CENTER — TOSS!" if absf(marker) <= 0.42 else "🟡 WAIT FOR CENTER"]

func toss_pizza() -> void:
    if not toss_active: return
    toss_attempts += 1
    var hit: bool = absf(sin(toss_phase)) <= 0.42
    if hit: toss_score += 1
    playtest_record("pizza_toss_attempt", {"hit":hit,"score":toss_score,"elapsed":20.0-toss_remaining})
    update_toss_labels()

func finish_pizza_toss() -> void:
    if not toss_active: return
    toss_active = false
    toss_action_button.disabled = true
    var reward: int = 0
    if toss_score >= 8 and not pizza_toss_reward_claimed:
        reward = 50
        wallet_coins += reward
        lifetime_coins += reward
        pizza_toss_reward_claimed = true
        _save_progress()
    toss_title.text = "🍕 PIZZA TOSS — RESULTS"
    toss_status.text = "%d accurate tosses / %d attempts\n%s" % [toss_score,toss_attempts,"BONUS +50 COINS!" if reward > 0 else "Score 8 to win!" if toss_score < 8 else "Already claimed: replay for practice!"]
    playtest_record("pizza_toss_finished", {"score":toss_score,"attempts":toss_attempts,"reward":reward})

func close_pizza_toss() -> void:
    toss_active = false
    if toss_panel != null: toss_panel.hide()
    if toss_title != null: toss_title.text = "🍕 PIZZA TOSS — BONUS STAGE"
    show_stage_select()

# Alpha 12.63: Opening sequence is INITIAL -> STORY 1 -> STORY 2 -> MAIN MENU.
# Story screens wait for player input. No progress or saved upgrades are reset.
var intro_layer: Control
var intro_background: TextureRect
var intro_fallback_label: Label
var intro_next_button: TextureButton
var intro_progress_bar: TextureRect
var intro_progress_material: ShaderMaterial
var intro_elapsed: float = 0.0
var intro_active: bool = false
var intro_page: int = 0
const INTRO_INITIAL_SECONDS := 3.0
const OPENING_IMAGES := [
    "res://assets/replacements/backgrounds/initial-screen.png",
    "res://assets/replacements/backgrounds/story1.png",
    "res://assets/replacements/backgrounds/story2.png"
]

func build_cinematic_intro() -> void:
    intro_layer = Control.new()
    intro_layer.name = "OpeningSequence"
    intro_layer.position = Vector2.ZERO
    intro_layer.size = Vector2(W, H)
    intro_layer.z_index = 900
    intro_layer.mouse_filter = Control.MOUSE_FILTER_STOP
    root_ui.add_child(intro_layer)

    intro_background = TextureRect.new()
    intro_background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    intro_background.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
    intro_background.stretch_mode = TextureRect.STRETCH_SCALE
    intro_background.mouse_filter = Control.MOUSE_FILTER_IGNORE
    intro_layer.add_child(intro_background)
    intro_fallback_label = Label.new()
    intro_fallback_label.name = "MissingOpeningArtworkFallback"
    intro_fallback_label.position = Vector2(280, 200)
    intro_fallback_label.size = Vector2(720, 210)
    intro_fallback_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    intro_fallback_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    intro_fallback_label.add_theme_font_size_override("font_size", 42)
    intro_fallback_label.add_theme_color_override("font_color", Color("fff3ce"))
    intro_fallback_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
    intro_layer.add_child(intro_fallback_label)

    # Alpha 12.83: the approved pizza-and-cheese loading bar replaces the
    # two plain ColorRect rectangles.  Artwork stays full resolution;
    # the shader reveals molten cheese along the original illustration.
    intro_progress_bar = TextureRect.new()
    intro_progress_bar.name = "ApprovedPizzaLoadingBar"
    intro_progress_bar.texture = preload("res://assets/ui/intro/glossy_pizza_cheese_progress_bar.png")
    intro_progress_bar.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
    intro_progress_bar.stretch_mode = TextureRect.STRETCH_SCALE
    # The transparent top/bottom margins in the approved PNG are intentional.
    # 600 x 338 maintains the image aspect ratio, placing the visible bar
    # around y = 574..672 in the 1280 x 720 logical landscape layout.
    intro_progress_bar.position = Vector2(340, 355)
    intro_progress_bar.size = Vector2(600, 338)
    intro_progress_bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
    intro_progress_material = ShaderMaterial.new()
    intro_progress_material.shader = preload("res://shaders/intro_pizza_fill.gdshader")
    intro_progress_material.set_shader_parameter("fill_ratio", 0.0)
    intro_progress_bar.material = intro_progress_material
    intro_layer.add_child(intro_progress_bar)

    # Alpha 12.75: approved green Next artwork is an actual clickable
    # TextureButton on Story 1 and Story 2, not text over a generic button.
    intro_next_button = TextureButton.new()
    intro_next_button.name = "StoryNextButton"
    intro_next_button.texture_normal = preload("res://assets/ui/story/next-button-story.png")
    intro_next_button.texture_hover = intro_next_button.texture_normal
    intro_next_button.texture_pressed = intro_next_button.texture_normal
    intro_next_button.ignore_texture_size = true
    intro_next_button.stretch_mode = TextureButton.STRETCH_SCALE
    # Preserve lower-right placement with the image's 2:1 proportions.
    intro_next_button.position = Vector2(1010, 585)
    intro_next_button.size = Vector2(220, 110)
    intro_next_button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
    intro_next_button.focus_mode = Control.FOCUS_ALL
    intro_next_button.pressed.connect(advance_opening_story)
    intro_layer.add_child(intro_next_button)

    start_cinematic_intro()

func start_cinematic_intro() -> void:
    intro_active = true
    intro_elapsed = 0.0
    if menu_panel != null:
        menu_panel.hide()
    show_opening_page(0)
    playtest_record("opening_started")

func show_opening_page(page: int) -> void:
    intro_page = page
    intro_elapsed = 0.0
    if page < 0 or page >= OPENING_IMAGES.size():
        finish_cinematic_intro()
        return
    var path: String = OPENING_IMAGES[page]
    intro_background.texture = load(path) if ResourceLoader.exists(path) else load("res://assets/ui/main_menu/main-menu-screen.png")
    # Approved story artwork is supplied; fallback text is only for missing assets.
    if intro_fallback_label != null:
        intro_fallback_label.visible = not ResourceLoader.exists(path)
        intro_fallback_label.text = ["PIZZA PANIC\nOPENING", "STORY 1\nThe restaurant adventure begins", "STORY 2\nGet ready to serve your first guests"][page]
    intro_progress_bar.visible = page == 0
    intro_progress_material.set_shader_parameter("fill_ratio", 0.0)
    intro_next_button.visible = page == 1 or page == 2
    intro_next_button.tooltip_text = "Continue to Main Menu" if page == 2 else "Next story"
    intro_layer.show()
    queue_redraw()

func advance_opening_story() -> void:
    if not intro_active or intro_page == 0:
        return
    if intro_page == 1:
        show_opening_page(2)
    else:
        finish_cinematic_intro()

func finish_cinematic_intro() -> void:
    if not intro_active:
        return
    intro_active = false
    intro_layer.hide()
    # Ensure the menu is restored after the story overlay closes.
    running = false
    show_main_menu()
    menu_panel.move_to_front()
    playtest_record("opening_finished")

func update_cinematic_intro(delta: float) -> void:
    if not intro_active:
        return
    if intro_page == 0:
        intro_elapsed += delta
        # A brief transition indicator, not a claim of measured asset-loading progress.
        intro_progress_material.set_shader_parameter("fill_ratio", minf(1.0, intro_elapsed / INTRO_INITIAL_SECONDS))
        if intro_elapsed >= INTRO_INITIAL_SECONDS:
            show_opening_page(1)


# Alpha 12.54: Character art is rendered as Godot textures, not painted placeholders.
# Poses: waitress [pizza delivery, order taking, dish carrying, serving];
# chef [idle, greeting, dough toss, finished pizza].
var waitress_poses: Array[Texture2D] = []
var waitress_walk_frames: Array[Texture2D] = []
var waitress_facing_left: bool = false
var waitress_is_walking: bool = false
var waitress_walk_time: float = 0.0
var chef_poses: Array[Texture2D] = []
# Alpha 12.69: approved chef walk visual cycle. The gameplay state machine is untouched.
var chef_walk_frames: Array[Texture2D] = []
const CHEF_WALK_SECONDS: float = 1.0
var chef_walk_remaining: float = 0.0
# Approved 4-frame sequences for preparation and oven-loading.
var chef_prepare_frames: Array[Texture2D] = []
var chef_oven_in_frames: Array[Texture2D] = []
const CHEF_OVEN_IN_SECONDS: float = 0.60
var chef_oven_in_remaining: float = 0.0
# Approved 4-frame oven-out turn, visual-only and triggered on cooking completion.
var chef_oven_out_frames: Array[Texture2D] = []
const CHEF_OVEN_OUT_SECONDS: float = 0.64
var chef_oven_out_remaining: float = 0.0

func load_character_art() -> void:
    waitress_poses.clear()
    waitress_walk_frames.clear()
    for walk_i in range(1, 9):
        waitress_walk_frames.append(load("res://assets/animations/waitress/walk/waitress_walk_%02d.png" % walk_i))
    chef_poses.clear()
    chef_walk_frames.clear()
    chef_prepare_frames.clear()
    chef_oven_in_frames.clear()
    chef_oven_out_frames.clear()
    for i in range(4):
        waitress_poses.append(load("res://assets/characters/waitress_%d.png" % i))
        chef_poses.append(load("res://assets/characters/chef_%d.png" % i))
    for i in range(1, 9):
        chef_walk_frames.append(load("res://assets/animations/chef/walk/chef_walk_%02d.png" % i))
    for i in range(1, 5):
        chef_prepare_frames.append(load("res://assets/animations/chef/prepare/chef_prepare_%02d.png" % i))
        chef_oven_in_frames.append(load("res://assets/animations/chef/oven_in/chef_oven_in_%02d.png" % i))
        chef_oven_out_frames.append(load("res://assets/animations/chef/oven_out/chef_oven_out_%02d.png" % i))

func draw_character_sprite(texture: Texture2D, feet: Vector2, target_height: float, moving: bool = false) -> void:
    if texture == null:
        return
    var image_size: Vector2 = texture.get_size()
    if image_size.x <= 0.0 or image_size.y <= 0.0:
        return
    var ratio: float = target_height / image_size.y
    var scaled: Vector2 = image_size * ratio
    draw_ellipse_approx(feet + Vector2(0, 2), Vector2(scaled.x * 0.24, 4), Color(0,0,0,0.20))
    var bob: float = sin(elapsed * 12.0) * 2.0 if moving else 0.0
    draw_texture_rect(texture, Rect2(feet - Vector2(scaled.x * 0.5, scaled.y + bob), scaled), false)

func waitress_pose_index() -> int:
    if not pending_cleaning.is_empty():
        return 2
    if not carried_pizzas.is_empty():
        return 0
    if not held_tickets.is_empty():
        return 1
    return 3 if task_table >= 0 else 1

func chef_pose_index() -> int:
    if not chef_pending_tables.is_empty() or chef_active_table >= 0:
        return 2
    if any_ready():
        return 3
    return 0

# Alpha 12.57: screen navigation foundation. Existing gameplay logic remains unchanged.
# Transparent PNGs from the asset mapper can skin these Controls later.
var menu_panel: Control
var settings_page: Control
var help_page: Control
var restaurant_page: PanelContainer
var tutorials_enabled: bool = true
var sfx_enabled: bool = true
var vibration_enabled: bool = true
var ui_language: String = "English"
var settings_language_label: Label
var help_topic_details: Label
var help_tab_highlights: Dictionary = {}
var help_basics_art: TextureRect
var help_active_topic: String = "Basics"
var level_failed_select_button: Button
var stage_prev_button: Button
var stage_next_button: Button
var competition_hub
var milestone_bonus_button: Button


# Alpha 12.74: main menu now uses the user's approved full-screen illustration and
# four independent image buttons. All navigation still calls the existing handlers.
func create_navigation_pages() -> void:
    menu_panel = Control.new()
    menu_panel.name = "MainMenu"
    menu_panel.position = Vector2.ZERO
    menu_panel.size = Vector2(W, H)
    menu_panel.z_index = 600
    menu_panel.mouse_filter = Control.MOUSE_FILTER_STOP

    var menu_art := TextureRect.new()
    menu_art.name = "ApprovedMainMenuArtwork"
    menu_art.position = Vector2.ZERO
    menu_art.size = Vector2(W, H)
    menu_art.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
    menu_art.stretch_mode = TextureRect.STRETCH_SCALE
    menu_art.mouse_filter = Control.MOUSE_FILTER_IGNORE
    menu_art.texture = load("res://assets/ui/main_menu/main-menu-screen.png")
    menu_panel.add_child(menu_art)

    # Board bounds in the 1280x720 game viewport: roughly x=905..1238,
    # y=265..662. Separate button images are click targets, not painted into
    # the background, so taps/clicks and keyboard focus remain functional.
    var main_actions := [
        ["PlayButton", "res://assets/ui/main_menu/play-button-main.png", "play", "Play"],
        ["ShopButton", "res://assets/ui/main_menu/shop-button-main.png", "upgrades", "Shop"],
        ["HowToPlayButton", "res://assets/ui/main_menu/how-button-main.png", "help", "How to Play"],
        ["SettingsButton", "res://assets/ui/main_menu/settings-button-main.png", "settings", "Settings"]
    ]
    for i in range(main_actions.size()):
        var entry: Array = main_actions[i]
        var image_button := TextureButton.new()
        image_button.name = str(entry[0])
        var texture: Texture2D = load(str(entry[1]))
        image_button.texture_normal = texture
        image_button.texture_hover = texture
        image_button.texture_pressed = texture
        image_button.ignore_texture_size = true
        image_button.stretch_mode = TextureButton.STRETCH_SCALE
        var main_button_rects := [Rect2(948, 311, 256, 81), Rect2(940, 390, 260, 78), Rect2(940, 469, 260, 79), Rect2(940, 547, 260, 78)]
        image_button.position = main_button_rects[i].position
        image_button.size = main_button_rects[i].size
        image_button.focus_mode = Control.FOCUS_ALL
        image_button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
        image_button.tooltip_text = str(entry[3])
        image_button.pressed.connect(open_menu_destination.bind(str(entry[2])))
        menu_panel.add_child(image_button)
    root_ui.add_child(menu_panel)

    # Alpha 12.81: use approved 4-row illustrated Settings instead of generic modal.
    var settings_file := ConfigFile.new()
    settings_file.load("user://pizza_panic_settings.cfg")
    tutorials_enabled = bool(settings_file.get_value("settings", "Show Tutorials", true))
    music_muted = not bool(settings_file.get_value("settings", "Music", true))
    sfx_enabled = bool(settings_file.get_value("settings", "Sound Effects", true))
    vibration_enabled = bool(settings_file.get_value("settings", "Vibration", true))
    ui_language = str(settings_file.get_value("settings", "Language", "English"))
    settings_page = load("res://scripts/settings_screen.gd").new()
    root_ui.add_child(settings_page)
    settings_page.call("setup", self)

    help_page = load("res://editable_screens/HowToPlay.tscn").instantiate()
    help_page.name = "HowToPlayPage"
    help_page.z_index = 650
    help_page.close_requested.connect(show_main_menu)
    root_ui.add_child(help_page)
    help_page.hide()
    restaurant_page = create_navigation_modal("RestaurantPage", "RESTAURANT", "Your restaurant upgrades and dining expansion are in the store. Purchases and unlocks are saved across levels.")
    var restaurant_body: VBoxContainer = restaurant_page.get_child(0) as VBoxContainer
    var store_link := Button.new()
    store_link.text = "OPEN UPGRADES"
    store_link.pressed.connect(func() -> void: open_menu_destination("upgrades"))
    restaurant_body.add_child(store_link)
    append_navigation_back(restaurant_page)
    menu_panel.hide()

func create_navigation_modal(node_name: String, heading_text: String, body_text: String) -> PanelContainer:
    var page := PanelContainer.new()
    page.name = node_name
    page.position = Vector2(290, 104)
    page.size = Vector2(700, 510)
    page.z_index = 92
    var content := VBoxContainer.new()
    content.add_theme_constant_override("separation", 16)
    page.add_child(content)
    var title_label := Label.new()
    title_label.text = heading_text
    title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    title_label.add_theme_font_size_override("font_size", 32)
    content.add_child(title_label)
    var description := Label.new()
    description.text = body_text
    description.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    description.custom_minimum_size = Vector2(600, 85)
    content.add_child(description)
    root_ui.add_child(page)
    page.hide()
    return page

func append_navigation_back(page: PanelContainer) -> void:
    var btn := Button.new()
    btn.text = "BACK TO MAIN MENU"
    btn.custom_minimum_size = Vector2(0, 53)
    btn.pressed.connect(show_main_menu)
    (page.get_child(0) as VBoxContainer).add_child(btn)

func save_navigation_preference(enabled: bool, key: String) -> void:
    var f := ConfigFile.new()
    f.load("user://pizza_panic_settings.cfg")
    f.set_value("settings", key, enabled)
    f.save("user://pizza_panic_settings.cfg")
    if key == "Music":
        music_muted = not enabled
        for player in music_players:
            player.volume_db = 0.0 if enabled else -80.0
    elif key == "Show Tutorials":
        tutorials_enabled = enabled
    elif key == "Sound Effects":
        sfx_enabled = enabled
    elif key == "Vibration":
        vibration_enabled = enabled

func change_navigation_language() -> void:
    ui_language = "Español" if ui_language == "English" else "English"
    settings_language_label.text = ui_language
    var f := ConfigFile.new()
    f.load("user://pizza_panic_settings.cfg")
    f.set_value("settings", "Language", ui_language)
    f.save("user://pizza_panic_settings.cfg")
    select_help_topic("Basics")

# Alpha 12.76: How To Play visual tabs, one selected at a time.
# The artwork for Basics is user-supplied; remaining topics await their copy.
func build_how_to_play_page() -> void:
    help_page = Control.new()
    help_page.name = "HowToPlayPage"
    help_page.size = Vector2(W, H)
    help_page.z_index = 92
    help_page.mouse_filter = Control.MOUSE_FILTER_STOP
    var background := TextureRect.new()
    background.name = "UserApprovedHowToPlayBackground"
    background.size = Vector2(W, H)
    background.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
    background.stretch_mode = TextureRect.STRETCH_SCALE
    background.texture = load("res://assets/ui/how_to_play/how-to-screen-v2.png")
    background.mouse_filter = Control.MOUSE_FILTER_IGNORE
    help_page.add_child(background)
    var topics := ["Basics", "Kitchen", "Customers", "Tips", "Reputation"]
    var files := ["basic-button-how.png", "kitchen-button-how.png", "customers-button-how.png", "tips-button-how.png", "reputation-button-how.png"]
    var photoshop_ys := [676.0, 859.0, 1044.0, 1227.0, 1403.0]
    for i in range(topics.size()):
        var tab := TextureButton.new()
        tab.name = topics[i] + "Tab"
        var texture: Texture2D = load("res://assets/ui/how_to_play/" + files[i])
        tab.texture_normal = texture
        tab.texture_hover = texture
        tab.texture_pressed = texture
        tab.ignore_texture_size = true
        tab.stretch_mode = TextureButton.STRETCH_SCALE
        tab.position = Vector2(199.0 * W / 3200.0, photoshop_ys[i] * H / 1806.0 - 1.0)
        tab.size = Vector2(640.0 * W / 3200.0, 182.0 * H / 1806.0)
        tab.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
        tab.pressed.connect(select_help_topic.bind(topics[i]))
        help_page.add_child(tab)
        help_tab_highlights[topics[i]] = tab
    var panel := ColorRect.new()
    panel.name = "HelpContentBackground"
    panel.color = Color("f9dfad")
    panel.position = Vector2(365, 285)
    panel.size = Vector2(785, 342)
    panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
    help_page.add_child(panel)
    help_page.set_meta("topic_back", panel)
    help_topic_details = Label.new()
    help_topic_details.name = "TopicInstructions"
    help_topic_details.position = Vector2(393, 300)
    help_topic_details.size = Vector2(734, 307)
    help_topic_details.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    help_topic_details.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    help_topic_details.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    help_topic_details.add_theme_color_override("font_color", Color("51220d"))
    help_topic_details.add_theme_font_size_override("font_size", 26)
    help_topic_details.mouse_filter = Control.MOUSE_FILTER_IGNORE
    help_page.add_child(help_topic_details)
    var close := TextureButton.new()
    close.name = "HowToPlayClose"
    var close_tex: Texture2D = load("res://assets/ui/how_to_play/close-button.png")
    close.texture_normal = close_tex
    close.texture_hover = close_tex
    close.texture_pressed = close_tex
    close.ignore_texture_size = true
    close.stretch_mode = TextureButton.STRETCH_SCALE
    close.position = Vector2(1103, 196)
    close.size = Vector2(81, 80)
    close.pressed.connect(show_main_menu)
    help_page.add_child(close)
    root_ui.add_child(help_page)
    help_page.hide()
    select_help_topic("Basics")

func select_help_topic(topic: String) -> void:
    if help_page == null:
        return
    help_active_topic = topic
    var show_details := true
    if help_page.has_meta("topic_back"):
        var detail_back: ColorRect = help_page.get_meta("topic_back")
        detail_back.visible = show_details
    if help_topic_details != null:
        help_topic_details.visible = show_details
        var descriptions := {
            "Basics": "BASICS\n\nSeat customers at available tables, take their orders, prepare and serve pizzas, collect payment, and clear tables before the next guests arrive.",
            "Kitchen": "KITCHEN\n\nRead each order ticket, prepare the correct pizza and ingredients, then use the oven. Place finished pizzas on the serving tray for delivery.",
            "Customers": "CUSTOMERS\n\nSeat waiting guests at available tables. Take their orders, deliver food before their patience runs out, collect payment, and clear the table.",
            "Tips": "TIPS\n\nServe customers quickly to earn extra patience and coins. Carry multiple pizzas with tray upgrades, and replay levels to improve your score.",
            "Reputation": "REPUTATION\n\nKeep guests happy to protect your five-star restaurant rating. Customers who leave lower your reputation. Replay levels to recover lost stars."
        }
        help_topic_details.text = str(descriptions.get(topic, ""))

func hide_navigation_pages() -> void:
    for page in [menu_panel, settings_page, help_page, restaurant_page]:
        if page != null: page.hide()

func show_main_menu() -> void:
    if running: return
    hide_level_complete_ui()
    hide_level_failed_ui()
    endless_mode = false
    hide_navigation_pages()
    if stage_panel != null: stage_panel.hide()
    if start_panel != null: start_panel.hide()
    if campaign_screens != null: campaign_screens.hide_screens()
    if showcase_panel != null: showcase_panel.hide()
    shop_return_to_menu = false
    if shop_open: toggle_shop()
    if menu_panel != null: menu_panel.show()
    queue_redraw()

func open_menu_destination(destination: String) -> void:
    if running: return
    hide_navigation_pages()
    # Level-select and pre-level screens are independent of navigation_pages.
    # Hide them before opening Settings/Help/Shop to prevent stale UI intercepting taps.
    if stage_panel != null: stage_panel.hide()
    if start_panel != null: start_panel.hide()
    if campaign_screens != null: campaign_screens.hide_screens()
    if showcase_panel != null: showcase_panel.hide()
    match destination:
        "play":
            endless_mode = false
            show_stage_select()
        "endless":
            begin_endless_from_menu()
        "competitions":
            competition_hub.open_leaderboards()
        "restaurant":
            restaurant_page.show()
        "upgrades":
            shop_return_to_menu = true
            show_level_brief()
            if not shop_open: toggle_shop()
        "settings":
            settings_page.z_index = 800
            settings_page.move_to_front()
            settings_page.call("refresh")
            settings_page.show()
        "help":
            select_help_topic("Basics")
            help_page.move_to_front()
            help_page.show()
    queue_redraw()

func _ready() -> void:
    load_mapped_table_art()
    ads_bridge = load("res://scripts/admob_bridge.gd").new()
    add_child(ads_bridge)
    ads_bridge.interstitial_finished.connect(_continue_after_ad)
    ads_bridge.rewarded_completed.connect(_credit_rewarded_coins)
    rng.randomize()
    load_character_art()
    playtest_begin()
    _load_progress()
    current_level = highest_unlocked
    art = load("res://assets/visual_target.png")
    if ResourceLoader.exists(LILITA_FONT_PATH):
        game_display_font = load(LILITA_FONT_PATH) as Font
    create_ui()
    install_pizza_panic_theme()
    create_pause_ui()
    initialize_music()
    create_shop_ui()
    create_tutorial_ui()
    create_rewarded_ad_ui()
    create_showcase_ui()
    create_pizza_toss_ui()
    create_competition_hub()
    create_chef_popup()
    prepare_scene()
    show_level_brief()
    show_stage_select()
    create_navigation_pages()
    create_level_complete_ui()
    create_level_failed_ui()
    campaign_screens = load("res://scripts/level_screens.gd").new()
    campaign_screens.name = "CampaignScreens"
    root_ui.add_child(campaign_screens)
    campaign_screens.setup(self)
    install_graphics_editor_shortcut()
    show_main_menu()
    update_ui()
    build_cinematic_intro()
    var motion := preload("res://scripts/ui_motion.gd").new()
    motion.name = "UIMotion"
    add_child(motion)
    motion.setup(root_ui, intro_background)
    queue_redraw()


# Alpha 12.55: reusable interactive illustrated-style UI skin.
# All buttons remain native Godot Controls: keyboard, mouse and touch work.
func pizza_style(fill: Color, edge: Color, corner: int = 14) -> StyleBoxFlat:
    var st := StyleBoxFlat.new()
    st.bg_color = fill
    st.border_color = edge
    st.set_border_width_all(4)
    st.set_corner_radius_all(corner)
    st.shadow_color = Color(0.17, 0.06, 0.02, 0.55)
    st.shadow_size = 5
    st.content_margin_left = 13.0
    st.content_margin_right = 13.0
    st.content_margin_top = 7.0
    st.content_margin_bottom = 7.0
    return st

func install_pizza_panic_theme() -> void:
    var t := Theme.new()
    if game_display_font != null:
        t.default_font = game_display_font
    t.set_stylebox("normal", "Button", pizza_style(Color("9a471f"), Color("e9a453")))
    t.set_stylebox("hover", "Button", pizza_style(Color("d17a24"), Color("ffe28d")))
    t.set_stylebox("pressed", "Button", pizza_style(Color("477b15"), Color("d6f774")))
    t.set_stylebox("focus", "Button", pizza_style(Color(0, 0, 0, 0), Color("fff0ad")))
    t.set_stylebox("disabled", "Button", pizza_style(Color("5a514b"), Color("82766b")))
    t.set_color("font_color", "Button", Color("fff4db"))
    t.set_color("font_hover_color", "Button", Color.WHITE)
    t.set_color("font_pressed_color", "Button", Color.WHITE)
    t.set_color("font_disabled_color", "Button", Color("c8bcb0"))
    t.set_font_size("font_size", "Button", 17)
    t.set_stylebox("panel", "PanelContainer", pizza_style(Color("f8dfa5"), Color("77350f"), 22))
    t.set_color("font_color", "Label", Color("4d230e"))
    root_ui.theme = t

func pizza_action_button(btn: Button, variant: String = "green") -> void:
    var bg := Color("2fae13") if variant == "green" else Color("0786d9") if variant == "blue" else Color("d63820")
    var edge := Color("a9fa56") if variant == "green" else Color("8ae6ff") if variant == "blue" else Color("ffc170")
    btn.add_theme_stylebox_override("normal", pizza_style(bg, edge, 17))
    btn.add_theme_stylebox_override("hover", pizza_style(bg.lightened(0.2), Color.WHITE, 17))
    btn.add_theme_stylebox_override("pressed", pizza_style(bg.darkened(0.25), edge, 17))
    btn.add_theme_color_override("font_color", Color.WHITE)
    btn.add_theme_font_size_override("font_size", 20)

func create_pause_ui() -> void:
    pause_button = TextureButton.new()
    pause_button.texture_normal = load("res://assets/ui/gameplay/pause-button.png")
    pause_button.ignore_texture_size = true
    pause_button.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
    pause_button.position = Vector2(1180, 6)
    pause_button.size = Vector2(70, 58)
    pause_button.z_index = 120
    pause_button.mouse_filter = Control.MOUSE_FILTER_STOP
    pause_button.pressed.connect(toggle_pause)
    root_ui.add_child(pause_button)
    pause_button.hide()

    pause_overlay = PanelContainer.new()
    pause_overlay.position = Vector2(265, 110)
    pause_overlay.size = Vector2(750, 500)
    pause_overlay.z_index = 200
    pause_overlay.mouse_filter = Control.MOUSE_FILTER_STOP
    var panel_style := StyleBoxTexture.new()
    panel_style.texture = load("res://assets/ui/gameplay/pause_wood_board.png")
    panel_style.texture_margin_left = 85.0
    panel_style.texture_margin_right = 85.0
    panel_style.texture_margin_top = 85.0
    panel_style.texture_margin_bottom = 85.0
    panel_style.content_margin_left = 86.0
    panel_style.content_margin_right = 86.0
    panel_style.content_margin_top = 75.0
    panel_style.content_margin_bottom = 72.0
    pause_overlay.add_theme_stylebox_override("panel", panel_style)
    var body := VBoxContainer.new()
    body.add_theme_constant_override("separation", 20)
    pause_overlay.add_child(body)
    var title := Label.new()
    title.text = "SHIFT PAUSED"
    title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    title.add_theme_font_size_override("font_size", 38)
    title.add_theme_color_override("font_color", Color("5b2b11"))
    body.add_child(title)
    var note := Label.new()
    note.text = "The clock, customers, chef and waitress are paused."
    note.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    note.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    note.add_theme_font_size_override("font_size", 19)
    note.add_theme_color_override("font_color", Color("5b2b11"))
    body.add_child(note)
    var resume_button := Button.new()
    resume_button.text = "RESUME LEVEL"
    resume_button.custom_minimum_size = Vector2(0, 74)
    resume_button.add_theme_font_size_override("font_size", 25)
    resume_button.pressed.connect(resume_shift)
    body.add_child(resume_button)
    var exit_button := Button.new()
    exit_button.text = "EXIT LEVEL - CHOOSE DAY"
    exit_button.custom_minimum_size = Vector2(0, 74)
    exit_button.add_theme_font_size_override("font_size", 22)
    exit_button.pressed.connect(exit_shift_to_days)
    body.add_child(exit_button)
    root_ui.add_child(pause_overlay)
    pause_overlay.hide()

func toggle_pause() -> void:
    playtest_record("pause_requested")
    if not running: return
    if shift_paused: resume_shift()
    else:
        shift_paused = true
        chef_popup_hidden_for_pause = chef_overlay != null and chef_overlay.visible
        if chef_popup_hidden_for_pause:
            chef_overlay.hide()
        pause_overlay.show()
        pause_button.hide()
        for player in music_players: player.stream_paused = true
        queue_redraw()

func resume_shift() -> void:
    playtest_record("resume_requested")
    if not running: return
    shift_paused = false
    pause_overlay.hide()
    if chef_popup_hidden_for_pause and chef_overlay != null and chef_active_table >= 0 and chef_active_table < tables.size() and str(tables[chef_active_table]["state"]) == "chef_wait" and not tables[chef_active_table]["party"].is_empty():
        chef_overlay.show()
    elif chef_popup_hidden_for_pause:
        chef_active_table = -1
        chef_selected.clear()
    chef_popup_hidden_for_pause = false
    pause_button.show()
    for player in music_players: player.stream_paused = false
    update_ui()
    queue_redraw()

func exit_shift_to_days() -> void:
    playtest_record("shift_abandoned")
    # Abandoned shifts do not award money, trophies, stars or unlock new days.
    shift_paused = false
    chef_popup_hidden_for_pause = false
    pause_overlay.hide()
    pause_button.hide()
    for player in music_players:
        player.stream_paused = false
        player.stop()
    running = false
    finished = false
    campaign_win = false
    action_queue.clear()
    if chef_overlay != null: chef_overlay.hide()
    if showcase_panel != null: showcase_panel.hide()
    prepare_scene()
    _save_progress()  # Preserve only previously earned progress and purchases.
    show_stage_select()
    message = "Shift exited. Select any unlocked day to preview its goals."
    update_ui()
    queue_redraw()



# Alpha 12.77 – visual overlay uses the uploaded 2048x1155 background and native
# 255x239 stars / 820x259 and 812x271 button artwork, unmodified on disk.
# Coordinates are in the game's 1280x720 virtual viewport, scaled by Godot.
func _level_complete_label(label_name: String, at: Vector2, dimensions: Vector2) -> Label:
    var label := Label.new()
    label.name = label_name
    label.position = at
    label.size = dimensions
    label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    if game_display_font != null:
        label.add_theme_font_override("font", game_display_font)
    label.add_theme_font_size_override("font_size", 47)
    label.add_theme_color_override("font_color", Color.WHITE)
    label.add_theme_color_override("font_outline_color", Color("141013"))
    label.add_theme_constant_override("outline_size", 9)
    label.mouse_filter = Control.MOUSE_FILTER_IGNORE
    level_complete_screen.add_child(label)
    return label

func _level_complete_button(button_name: String, filename: String, at: Vector2, dimensions: Vector2, action: Callable) -> TextureButton:
    var button := TextureButton.new()
    button.name = button_name
    var texture: Texture2D = load("res://assets/ui/level_complete/" + filename)
    button.texture_normal = texture
    button.texture_hover = texture
    button.texture_pressed = texture
    button.ignore_texture_size = true
    button.stretch_mode = TextureButton.STRETCH_SCALE
    button.position = at
    button.size = dimensions
    button.pivot_offset = dimensions * 0.5
    button.mouse_filter = Control.MOUSE_FILTER_STOP
    button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
    button.focus_mode = Control.FOCUS_ALL
    button.pressed.connect(action)
    level_complete_screen.add_child(button)
    return button

func create_level_complete_ui() -> void:
    level_complete_screen = Control.new()
    level_complete_screen.name = "LevelCompleteScreen"
    level_complete_screen.position = Vector2.ZERO
    level_complete_screen.size = Vector2(W, H)
    level_complete_screen.z_index = 380
    level_complete_screen.mouse_filter = Control.MOUSE_FILTER_STOP
    level_complete_screen.clip_contents = true
    root_ui.add_child(level_complete_screen)

    var background := TextureRect.new()
    background.name = "ApprovedLevelCompleteBackground"
    background.texture = load("res://assets/ui/level_complete/complete-level.png")
    background.position = Vector2.ZERO
    background.size = Vector2(W, H)
    background.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
    background.stretch_mode = TextureRect.STRETCH_SCALE
    background.size = Vector2(W, H)
    background.mouse_filter = Control.MOUSE_FILTER_IGNORE
    level_complete_screen.add_child(background)

    var gray: Texture2D = load("res://assets/ui/level_complete/gray-star.png")
    for star_index in range(3):
        var star := TextureRect.new()
        star.name = "Star%d" % (star_index + 1)
        star.texture = gray
        star.position = Vector2(665 + star_index * 114, 288)
        star.size = Vector2(103, 98)
        star.pivot_offset = star.size * 0.5
        star.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
        star.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
        star.size = Vector2(103, 98)
        star.mouse_filter = Control.MOUSE_FILTER_IGNORE
        level_complete_screen.add_child(star)
        level_complete_stars.append(star)

    # Lower green counters in the approved art: coins and guests served / arrived.
    level_complete_coin_value = _level_complete_label("EarnedCoins", Vector2(655, 405), Vector2(134, 66))
    level_complete_people_value = _level_complete_label("ServedGuests", Vector2(960, 405), Vector2(140, 66))
    var replay := _level_complete_button("ReplaySameLevel", "replay-button(2).png", Vector2(490, 577), Vector2(316, 101), Callable(self, "_level_complete_replay"))
    replay.tooltip_text = "Replay this level; only improvements to your best score add coins."
    level_complete_next_button = _level_complete_button("NextLevel", "next-level-button(2).png", Vector2(835, 577), Vector2(316, 101), Callable(self, "_level_complete_next"))
    level_complete_next_button.tooltip_text = "Continue to the next unlocked level."
    level_complete_screen.hide()

func show_level_complete_ui(stars_earned: int, coins_awarded: int, guests_served: int, guests_arrived: int) -> void:
    if level_complete_screen == null:
        return
    var yellow: Texture2D = load("res://assets/ui/level_complete/yellow-star.png")
    var gray: Texture2D = load("res://assets/ui/level_complete/gray-star.png")
    for star_index in range(level_complete_stars.size()):
        var star: TextureRect = level_complete_stars[star_index]
        star.texture = yellow if star_index < stars_earned else gray
        star.scale = Vector2(0.6, 0.6)
        var tween := create_tween()
        tween.tween_property(star, "scale", Vector2.ONE, 0.32).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT).set_delay(float(star_index) * 0.12)
    level_complete_coin_value.text = str(coins_awarded)
    level_complete_coin_value.tooltip_text = "Coins actually added to the saved wallet on this run; replays award only new-best improvements."
    level_complete_people_value.text = "%d/%d" % [guests_served, maxi(guests_arrived, guests_served)]
    level_complete_people_value.tooltip_text = "People served / people who arrived during this level."
    level_complete_next_button.visible = current_level < LEVELS.size() - 1
    # Remove the old text panel and make these two real image buttons interactive.
    if start_panel != null:
        start_panel.hide()
    if shop_button != null:
        shop_button.hide()
    if stage_panel != null:
        stage_panel.hide()
    level_complete_screen.show()

func hide_level_complete_ui() -> void:
    if level_complete_screen != null:
        level_complete_screen.hide()

func _level_complete_replay() -> void:
    hide_level_complete_ui()
    pending_bonus_day_after_results = -1
    # Replays preserve the original incremental-wallet and best-star rules.
    try_start_game()

func _level_complete_next() -> void:
    hide_level_complete_ui()
    var bonus_day: int = pending_bonus_day_after_results
    pending_bonus_day_after_results = -1
    next_level()
    # Bonus prompts and optional upgrade offers now wait until the player has
    # acknowledged the completion screen instead of covering the result.
    if bonus_day > 0 and not competition_hub.already_seen(bonus_day):
        competition_hub.call_deferred("open_game", bonus_day)
    elif affordable_upgrade_count() > 0:
        offer_affordable_upgrades()



# Alpha 12.78: user-approved fail art. All image files retain their source
# dimensions; only the on-screen TextureRects are scaled to 1280x720.
# All controls sit over a full-screen overlay, so the old result panel cannot
# block or duplicate clicks. These only appear for unsuccessful campaign days.
func _level_failed_label(label_name: String, at: Vector2, dimensions: Vector2) -> Label:
    var label := Label.new()
    label.name = label_name
    label.position = at
    label.size = dimensions
    label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    if game_display_font != null:
        label.add_theme_font_override("font", game_display_font)
    label.add_theme_font_size_override("font_size", 47)
    label.add_theme_color_override("font_color", Color.WHITE)
    label.add_theme_color_override("font_outline_color", Color("141013"))
    label.add_theme_constant_override("outline_size", 9)
    label.mouse_filter = Control.MOUSE_FILTER_IGNORE
    level_failed_screen.add_child(label)
    return label

func _level_failed_button(button_name: String, filename: String, at: Vector2, dimensions: Vector2, action: Callable) -> TextureButton:
    var button := TextureButton.new()
    button.name = button_name
    var texture: Texture2D = load("res://assets/ui/level_failed/" + filename)
    button.texture_normal = texture
    button.texture_hover = texture
    button.texture_pressed = texture
    button.ignore_texture_size = true
    button.stretch_mode = TextureButton.STRETCH_SCALE
    button.position = at
    button.size = dimensions
    button.pivot_offset = dimensions * 0.5
    button.mouse_filter = Control.MOUSE_FILTER_STOP
    button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
    button.focus_mode = Control.FOCUS_ALL
    button.pressed.connect(action)
    level_failed_screen.add_child(button)
    return button

func create_level_failed_ui() -> void:
    level_failed_screen = Control.new()
    level_failed_screen.name = "LevelFailedScreen"
    level_failed_screen.position = Vector2.ZERO
    level_failed_screen.size = Vector2(W, H)
    level_failed_screen.z_index = 381
    level_failed_screen.mouse_filter = Control.MOUSE_FILTER_STOP
    level_failed_screen.clip_contents = true
    root_ui.add_child(level_failed_screen)

    var background := TextureRect.new()
    background.name = "ApprovedLevelFailedBackground"
    background.texture = load("res://assets/ui/level_failed/fail-level-screen.png")
    background.position = Vector2.ZERO
    background.size = Vector2(W, H)
    background.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
    background.stretch_mode = TextureRect.STRETCH_SCALE
    background.size = Vector2(W, H)
    background.mouse_filter = Control.MOUSE_FILTER_IGNORE
    level_failed_screen.add_child(background)

    var gray: Texture2D = load("res://assets/ui/level_complete/gray-star.png")
    for star_index in range(3):
        var star := TextureRect.new()
        star.name = "FailedGrayStar%d" % (star_index + 1)
        star.texture = gray
        star.position = Vector2(665 + star_index * 114, 220)
        star.size = Vector2(103, 98)
        star.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
        star.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
        star.size = Vector2(103, 98)
        star.mouse_filter = Control.MOUSE_FILTER_IGNORE
        level_failed_screen.add_child(star)

    # Illustrated counters: coins earned on this attempt and customers served/arrived.
    level_failed_coins_value = _level_failed_label("FailedEarnedCoins", Vector2(645, 360), Vector2(134, 66))
    level_failed_guests_value = _level_failed_label("FailedServedGuests", Vector2(948, 360), Vector2(140, 66))
    level_failed_replay_button = _level_failed_button("ReplayFailedLevel", "replay-button(3).png", Vector2(490, 577), Vector2(316, 101), Callable(self, "_level_failed_replay"))
    level_failed_replay_button.tooltip_text = "Replay this level. Failed attempts do not award campaign coins."
    level_failed_select_button_art = _level_failed_button("SelectLevelAfterFailure", "select-level-button-fail.png", Vector2(846, 577), Vector2(316, 101), Callable(self, "_level_failed_select_level"))
    level_failed_select_button_art.tooltip_text = "Open level selection; your unlocked progress is preserved."
    level_failed_screen.hide()

func show_level_failed_ui(coins_awarded: int, guests_served: int, guests_arrived: int) -> void:
    if level_failed_screen == null:
        return
    hide_level_complete_ui()
    level_failed_coins_value.text = str(coins_awarded)
    level_failed_coins_value.tooltip_text = "Coins added to your wallet in this attempt. Failed campaign runs do not award coins."
    level_failed_guests_value.text = "%d/%d" % [guests_served, maxi(guests_arrived, guests_served)]
    level_failed_guests_value.tooltip_text = "Guests served / guests who arrived during this level."
    if start_panel != null: start_panel.hide()
    if shop_button != null: shop_button.hide()
    if stage_panel != null: stage_panel.hide()
    level_failed_screen.show()
    level_failed_replay_button.grab_focus()

func hide_level_failed_ui() -> void:
    if level_failed_screen != null:
        level_failed_screen.hide()

func _level_failed_replay() -> void:
    hide_level_failed_ui()
    pending_bonus_day_after_results = -1
    # Same retry path as the existing failed-results button. Keeps wallet,
    # unlocks and best scores governed by the original start_game/end_game logic.
    try_start_game()

func _level_failed_select_level() -> void:
    hide_level_failed_ui()
    pending_bonus_day_after_results = -1
    show_stage_select()

func create_ui() -> void:
    root_ui = Control.new()
    root_ui.name = "HUD"
    root_ui.set_anchors_preset(Control.PRESET_FULL_RECT)
    root_ui.mouse_filter = Control.MOUSE_FILTER_IGNORE
    add_child(root_ui)
    hud = Label.new()
    hud.position = Vector2(24, 11)
    hud.size = Vector2(1050, 49)
    hud.add_theme_color_override("font_color", Color("fff2d1"))
    hud.add_theme_font_size_override("font_size", 20)
    hud.mouse_filter = Control.MOUSE_FILTER_IGNORE
    root_ui.add_child(hud)
    # The old full-width line covered the top illustrated HUD. Keep it hidden
    # as a compatibility placeholder; five separate values now fit the art.
    hud.hide()
    var counter_layout := [
        ["level", Vector2(40, 13), Vector2(82, 46), 21, Color("fff3d1")],
        ["clock", Vector2(181, 12), Vector2(115, 46), 24, Color("ffffff")],
        ["coins", Vector2(334, 13), Vector2(112, 46), 22, Color("fff1b8")],
        ["stars", Vector2(462, 15), Vector2(100, 42), 20, Color("fff5ce")],
        ["guests", Vector2(584, 13), Vector2(53, 45), 22, Color("ffffff")]
    ]
    for spec in counter_layout:
        var label := Label.new()
        label.name = "HUD_" + str(spec[0])
        label.position = spec[1]
        label.size = spec[2]
        label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
        label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
        # Explicitly bind Lilita One to each gameplay HUD counter.
        # Do not rely solely on root theme inheritance (custom themes may override it).
        if game_display_font != null:
            label.add_theme_font_override("font", game_display_font)
        label.add_theme_font_size_override("font_size", spec[3])
        label.add_theme_color_override("font_color", spec[4])
        label.add_theme_color_override("font_shadow_color", Color("43210e"))
        label.add_theme_constant_override("shadow_offset_x", 1)
        label.add_theme_constant_override("shadow_offset_y", 2)
        label.mouse_filter = Control.MOUSE_FILTER_IGNORE
        root_ui.add_child(label)
        hud_counters[str(spec[0])] = label
    message_label = Label.new()
    message_label.position = Vector2(224, 673)
    message_label.size = Vector2(870, 27)
    message_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
    message_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    message_label.add_theme_color_override("font_color", Color("fff1d8"))
    message_label.add_theme_font_size_override("font_size", 14)
    message_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
    root_ui.add_child(message_label)
    start_panel = PanelContainer.new()
    start_panel.position = Vector2(310, 75)
    start_panel.size = Vector2(660, 550)
    var content := VBoxContainer.new()
    content.name = "VBoxContainer"
    content.add_theme_constant_override("separation", 7)
    start_panel.add_child(content)
    var heading := Label.new()
    heading.name = "Title"
    heading.text = "PIZZA PANIC!"
    heading.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    heading.add_theme_font_size_override("font_size", 30)
    content.add_child(heading)
    panel_title = heading
    var sub := Label.new()
    sub.name = "Description"
    sub.text = "LEVEL 1 - GRAND OPENING\n\nSeat parties of 2, 3 or 4 at 2- or 4-seat tables.\nTake orders, deliver pizza, collect payment, and clean.\n\nTARGET: $220"
    sub.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    sub.add_theme_font_size_override("font_size", 17)
    sub.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    # Long goals must scroll within the panel rather than pushing controls offscreen.
    var brief_scroll := ScrollContainer.new()
    brief_scroll.custom_minimum_size = Vector2(610, 315)
    brief_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
    brief_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
    content.add_child(brief_scroll)
    sub.custom_minimum_size = Vector2(610, 0)
    brief_scroll.add_child(sub)
    panel_description = sub
    start_button = Button.new()
    start_button.text = "START RESTAURANT"
    start_button.custom_minimum_size = Vector2(0, 42)
    start_button.pressed.connect(try_start_game)
    content.add_child(start_button)
    pizza_action_button(start_button, "green")
    retry_button = Button.new()
    retry_button.text = "PLAY AGAIN"
    retry_button.custom_minimum_size = Vector2(0, 42)
    retry_button.pressed.connect(func() -> void:
        if campaign_win:
            next_level()
        else:
            try_start_game()
    )
    content.add_child(retry_button)
    pizza_action_button(retry_button, "blue")
    level_failed_select_button = Button.new()
    level_failed_select_button.text = "SELECT LEVEL"
    level_failed_select_button.custom_minimum_size = Vector2(0, 45)
    pizza_action_button(level_failed_select_button, "blue")
    level_failed_select_button.pressed.connect(show_stage_select)
    content.add_child(level_failed_select_button)
    level_failed_select_button.hide()
    var menu_back := Button.new()
    menu_back.name = "BackToMainMenuButton"
    menu_back.text = "MAIN MENU"
    menu_back.custom_minimum_size = Vector2(0, 34)
    menu_back.pressed.connect(show_main_menu)
    content.add_child(menu_back)
    retry_button.hide()
    playtest_log_button = Button.new()
    playtest_log_button.text = "OPEN PLAYTEST LOGS FOLDER"
    playtest_log_button.custom_minimum_size = Vector2(0, 34)
    playtest_log_button.pressed.connect(playtest_open_folder)
    content.add_child(playtest_log_button)
    root_ui.add_child(start_panel)
    create_stage_ui()

# Campaign browser: five pages of twenty levels; locked levels retain their restrictions.
func create_stage_ui() -> void:
    stage_select_button = Button.new()
    stage_select_button.text = "← BACK TO DAY SELECTION"
    stage_select_button.custom_minimum_size = Vector2(0, 40)
    stage_select_button.pressed.connect(show_stage_select)
    var brief_content: VBoxContainer = start_panel.get_child(0) as VBoxContainer
    brief_content.add_child(stage_select_button)
    brief_content.move_child(stage_select_button, 2)

    stage_panel = PanelContainer.new()
    stage_panel.position = Vector2(205, 55)
    stage_panel.size = Vector2(870, 625)
    stage_panel.z_index = 40
    var body := VBoxContainer.new()
    body.add_theme_constant_override("separation", 9)
    stage_panel.add_child(body)
    var heading := Label.new()
    heading.text = "PIZZA PANIC  |  CHOOSE YOUR ADVENTURE"
    heading.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    heading.add_theme_font_size_override("font_size", 26)
    body.add_child(heading)
    var chapter_bar := HBoxContainer.new()
    for j in range(STAGE_NAMES.size()):
        var tab := Button.new()
        tab.text = "STAGE %d" % (j + 1)
        tab.tooltip_text = STAGE_NAMES[j]
        tab.size_flags_horizontal = Control.SIZE_EXPAND_FILL
        tab.pressed.connect(select_stage_page.bind(j))
        chapter_bar.add_child(tab)
    body.add_child(chapter_bar)
    var scroll := ScrollContainer.new()
    scroll.custom_minimum_size = Vector2(800, 355)
    scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
    body.add_child(scroll)
    stage_cards = VBoxContainer.new()
    stage_cards.add_theme_constant_override("separation", 5)
    scroll.add_child(stage_cards)
    var footer := HBoxContainer.new()
    var wallet := Label.new()
    wallet.text = "Choose a day to see its goals, then START LEVEL."
    wallet.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    wallet.add_theme_font_size_override("font_size", 13)
    footer.add_child(wallet)
    stage_back_button = Button.new()
    stage_back_button.text = "BACK TO MAIN MENU"
    stage_back_button.pressed.connect(show_main_menu)
    footer.add_child(stage_back_button)
    body.add_child(footer)
    root_ui.add_child(stage_panel)
    stage_panel.hide()
    # Convenient permanent navigation from the day-selection page.
    var extras := HBoxContainer.new()
    for spec in [["TROPHIES", "trophies"], ["PERSONAL BESTS", "leaderboard"], ["COIN SHOP", "coins"]]:
        var b := Button.new()
        b.text = spec[0]
        b.custom_minimum_size = Vector2(0, 42)
        b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
        b.pressed.connect(open_showcase.bind(spec[1]))
        extras.add_child(b)
    body.add_child(extras)
    var chapter_arrows := HBoxContainer.new()
    stage_prev_button = Button.new()
    stage_prev_button.text = "◀ PREVIOUS 20 LEVELS"
    stage_prev_button.custom_minimum_size = Vector2(240, 45)
    stage_prev_button.pressed.connect(change_chapter_page.bind(-1))
    chapter_arrows.add_child(stage_prev_button)
    var chapter_spacer := Control.new()
    chapter_spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    chapter_arrows.add_child(chapter_spacer)
    stage_next_button = Button.new()
    stage_next_button.text = "NEXT 20 LEVELS ▶"
    stage_next_button.custom_minimum_size = Vector2(240, 45)
    stage_next_button.pressed.connect(change_chapter_page.bind(1))
    chapter_arrows.add_child(stage_next_button)
    body.add_child(chapter_arrows)
    var replay_intro := Button.new()
    replay_intro.text = "▶ REPLAY OPENING STORY"
    replay_intro.custom_minimum_size = Vector2(0, 42)
    replay_intro.pressed.connect(start_cinematic_intro)
    body.add_child(replay_intro)

func show_stage_select() -> void:
    if running: return
    hide_level_complete_ui()
    hide_level_failed_ui()
    endless_mode = false
    if shop_open: toggle_shop()
    stage_select_page = clampi(stage_select_page, 0, STAGE_NAMES.size() - 1)
    refresh_stage_select()
    start_panel.hide()
    stage_panel.show()
    if campaign_screens != null:
        campaign_screens.show_select()
        stage_panel.hide()
    if toss_launch_button != null:
        toss_launch_button.visible = false # All four mini-games now live in COMPETITIONS
    if showcase_panel != null: showcase_panel.hide()

func close_stage_select() -> void:
    if toss_launch_button != null: toss_launch_button.hide()
    stage_panel.hide()
    show_level_brief()

func change_chapter_page(direction: int) -> void:
    select_stage_page(stage_select_page + direction)

func select_stage_page(page: int) -> void:
    stage_select_page = clampi(page, 0, STAGE_NAMES.size() - 1)
    refresh_stage_select()
    if campaign_screens != null: campaign_screens.refresh_select()

func choose_replay_level(level_id: int) -> void:
    if running or level_id > highest_unlocked or level_id >= LEVELS.size(): return
    # Art-flow navigation: selecting a day previews its goals before the shift.
    if shop_open: toggle_shop()
    open_level(level_id)
    if stage_panel != null: stage_panel.hide()
    if menu_panel != null: menu_panel.hide()

func refresh_stage_select() -> void:
    if stage_prev_button != null:
        stage_prev_button.disabled = stage_select_page <= 0
    if stage_next_button != null:
        stage_next_button.disabled = stage_select_page >= STAGE_NAMES.size() - 1
    for child in stage_cards.get_children(): child.queue_free()
    var chapter := Label.new()
    chapter.text = "STAGE %d  •  %s  •  DAYS %d–%d" % [stage_select_page + 1, STAGE_NAMES[stage_select_page], stage_select_page * DAYS_PER_STAGE + 1, (stage_select_page+1) * DAYS_PER_STAGE]
    chapter.add_theme_font_size_override("font_size", 22)
    chapter.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    stage_cards.add_child(chapter)
    var intro := Label.new()
    intro.text = STAGE_TAGLINES[stage_select_page] + "   Select a day to review its goals before starting. ★ Replays can recover review stars!"
    intro.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    stage_cards.add_child(intro)
    for slot in range(DAYS_PER_STAGE):
        var day_id: int = stage_select_page * DAYS_PER_STAGE + slot
        var available: bool = day_id < LEVELS.size() and day_id <= highest_unlocked
        var row := HBoxContainer.new()
        var number := Label.new()
        number.text = "DAY %02d" % (day_id+1)
        number.custom_minimum_size = Vector2(95, 31)
        number.add_theme_font_size_override("font_size", 16)
        row.add_child(number)
        var name := Label.new()
        name.text = str(LEVELS[day_id]["name"]) if day_id < LEVELS.size() else "New challenge coming soon"
        name.custom_minimum_size = Vector2(335, 31)
        name.add_theme_font_size_override("font_size", 16)
        row.add_child(name)
        var star_label := Label.new()
        var stars: int = int(best_stars.get(str(day_id), 0))
        star_label.text = "★".repeat(stars) + "☆".repeat(3 - stars) if stars > 0 else "—"
        star_label.custom_minimum_size = Vector2(93, 31)
        row.add_child(star_label)
        var play := Button.new()
        var day_walkouts: int = int(best_walkouts.get(str(day_id), 0))
        if stars > 0 and day_walkouts > 0:
            play.text = "★ RECOVER (%d)" % day_walkouts
            play.tooltip_text = "Replay this day with fewer unhappy walkouts to recover up to %s review stars. Your best walkout record is kept." % ("%.2f" % (float(day_walkouts) / 3.0))
        else:
            play.text = "REPLAY DAY" if stars > 0 else "PLAY DAY" if available else "LOCKED"
        play.disabled = not available
        play.custom_minimum_size = Vector2(125, 34)
        play.pressed.connect(choose_replay_level.bind(day_id))
        row.add_child(play)
        if available:
            pizza_action_button(play, "blue" if stars > 0 else "green")
        stage_cards.add_child(row)


# ALPHA 10: Achievement and personal-best previews. Data is local to this installation.
# Apple Game Center / Google Play Games and cross-platform servers are planned, NOT linked.
func create_showcase_ui() -> void:
    showcase_panel = PanelContainer.new()
    showcase_panel.position = Vector2(235, 75)
    showcase_panel.size = Vector2(810, 585)
    showcase_panel.z_index = 55
    var outer := VBoxContainer.new()
    outer.add_theme_constant_override("separation", 10)
    showcase_panel.add_child(outer)
    var bar := HBoxContainer.new()
    showcase_title = Label.new()
    showcase_title.add_theme_font_size_override("font_size", 26)
    showcase_title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    bar.add_child(showcase_title)
    var back := Button.new()
    back.text = "X  CLOSE"
    back.pressed.connect(close_showcase)
    bar.add_child(back)
    outer.add_child(bar)
    var scroll := ScrollContainer.new()
    scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
    outer.add_child(scroll)
    showcase_body = VBoxContainer.new()
    showcase_body.custom_minimum_size = Vector2(730, 0)
    showcase_body.add_theme_constant_override("separation", 8)
    scroll.add_child(showcase_body)
    root_ui.add_child(showcase_panel)
    showcase_panel.hide()

func showcase_line(text_value: String, font_size: int = 17) -> void:
    var l := Label.new()
    l.text = text_value
    l.add_theme_font_size_override("font_size", font_size)
    l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    showcase_body.add_child(l)

func clear_showcase() -> void:
    for c in showcase_body.get_children():
        c.queue_free()

func open_showcase(section: String) -> void:
    if running: return
    showcase_from_stage = stage_panel.visible
    if shop_open: toggle_shop()
    stage_panel.hide()
    start_panel.hide()
    clear_showcase()
    match section:
        "trophies":
            showcase_title.text = "TROPHY CABINET"
            showcase_line("Your restaurant achievements are saved on this device.", 16)
            var three_star_days: int = 0
            for value in best_stars.values():
                if int(value) >= 3: three_star_days += 1
            add_trophy("FIRST SLICE", total_guests_served, 10, "Serve 10 guests")
            add_trophy("PIZZA MASTER - BRONZE", total_pizzas_served, 50, "Serve 50 correctly prepared pizzas")
            add_trophy("PIZZA MASTER - SILVER", total_pizzas_served, 250, "Serve 250 correctly prepared pizzas")
            add_trophy("PIZZA MASTER - GOLD", total_pizzas_served, 1000, "Serve 1,000 correctly prepared pizzas")
            add_trophy("PERFECT CHEF", three_star_days, 5, "Earn 3 stars on 5 different days")
            add_trophy("SPOTLESS SHIFT", total_perfect_days, 5, "Win 5 shifts with no walkouts or wrong pizzas")
            add_trophy("PIZZA TYCOON", best_stars.size(), 100, "Complete all 100 campaign days")
        "leaderboard":
            showcase_title.text = "RESTAURANT REVIEWS & MONEY"
            showcase_line("OVERALL RESTAURANT REVIEW: %s" % review_text(), 23)
            showcase_line("Each 20-day chapter milestone recommends 4.00 / 5 stars. Each best-record walkout costs one-third star.", 16)
            showcase_line("Replaying a level with fewer walkouts replaces its old penalty. Only a higher earnings record pays the difference.", 16)
            showcase_line("CURRENT WALLET: %d  |  LIFETIME EARNED: %d" % [wallet_coins, lifetime_coins], 20)
            var ranked: Array = []
            for key in best_cash.keys():
                ranked.append({"day":int(key), "cash":int(best_cash[key])})
            ranked.sort_custom(func(a: Dictionary, b: Dictionary) -> bool: return int(a["cash"]) > int(b["cash"]))
            showcase_line("BEST DAY SCORES AND WALKOUTS", 20)
            if ranked.is_empty(): showcase_line("No scores yet. Complete your first shift to appear here!")
            for index in range(mini(ranked.size(), 10)):
                var record: Dictionary = ranked[index]
                var day: int = int(record["day"])
                showcase_line("Day %02d | Best %d coins | Best walkouts %d | %s" % [day + 1, int(best_level_payout.get(str(day), record["cash"])), int(best_walkouts.get(str(day), 0)), "★".repeat(int(best_stars.get(str(day), 0)))])
            showcase_line("Lifetime earned: %d coins  |  Guests served: %d" % [lifetime_coins, total_guests_served])
            showcase_line("Personal results are saved locally on this computer.", 14)
        "coins":
            showcase_title.text = "COIN SHOP - PREVIEW"
            showcase_line("YOUR CURRENT WALLET: %d GAME COINS" % wallet_coins, 21)
            showcase_line("Earn coins in shifts and spend them on the regular Store upgrades.")
            showcase_line("These are proposed real-money bundles. Billing is NOT active.", 15)
            var bundles := [["Starter Pouch", 500, "$0.99"], ["Chef's Wallet", 1400, "$1.99"], ["Pizza Vault", 4000, "$4.99"], ["Restaurant Tycoon", 10000, "$9.99"]]
            for bundle in bundles:
                var btn := Button.new()
                btn.text = "%s     |     %d coins     |     %s     |     PREVIEW" % [bundle[0], bundle[1], bundle[2]]
                btn.custom_minimum_size = Vector2(0, 57)
                btn.pressed.connect(demo_coin_notice)
                showcase_body.add_child(btn)
            demo_shop_message = Label.new()
            demo_shop_message.text = "No payment is collected. No coins will be added by these preview buttons."
            demo_shop_message.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
            showcase_body.add_child(demo_shop_message)
    showcase_panel.show()

func add_trophy(trophy_name: String, progress: int, target: int, detail: String) -> void:
    var unlocked: bool = progress >= target
    showcase_line("%s   %s    %d/%d\n       %s" % ["🏆" if unlocked else "🔒", trophy_name, mini(progress, target), target, detail], 18)

func demo_coin_notice() -> void:
    if demo_shop_message != null:
        demo_shop_message.text = "COIN SHOP DEMO ONLY: Purchases disabled. Play shifts to earn coins."

func close_showcase() -> void:
    showcase_panel.hide()
    if showcase_from_stage:
        show_stage_select()
    else:
        show_level_brief()

func prepare_scene() -> void:
    if chef_overlay != null: chef_overlay.hide()
    chef_pending_tables.clear()
    chef_saved_selections.clear()
    chef_selected.clear()
    chef_active_table = -1
    tables.clear()
    for i in range(seating_table_count()):
        var number: int = TABLE_NUMBERS[i]
        # All three starter tables are yellow on Days 1-2, even on replays.
        # From Day 3 on, each owned, separately purchased conversion is permanent.
        var conversion_id: String = "chairs" if number == 7 else "chairs_%d" % number
        var seat_count: int = 4 if (endless_mode or current_level >= 2) and has_upgrade(conversion_id) else 2
        tables.append({"number":number, "state":"empty", "party":{}, "timer":0.0, "seats":seat_count, "clean_left":1, "recipe_verified":false})
    queue.clear()
    selected_party = -1
    next_party_id = 0
    waitress_pos = Vector2(1040, 600)
    task_table = -1
    task_type = ""
    action_queue.clear()
    held_tickets.clear()
    carried_pizzas.clear()
    robot_targets.clear()
    robot_target_index = 0
    robot_busy = false
    robot_pickup_delay = 0.0
    robot_pos = Vector2(1120, 352)
    station_task = ""
    pending_cleaning.clear()
    cleaning_kits.clear()
    remaining = float(cfg("time"))
    spawn_clock = 0.0
    party_arrival_times.clear()
    next_arrival_slot = 0
    shift_roster_closed = false
    overtime_seconds = 120.0 # retained for save compatibility; not a gameplay deadline
    closing_announced = false
    elapsed = 0.0
    cash = 0
    served = 0
    guests_arrived_this_shift = 0
    chain = 0
    lost = 0
    float_text.clear()
    particles.clear()
    progress_count = 0
    clean_count = 0
    big_parties = 0
    vip_count = 0
    correct_count = 0
    wrong_count = 0
    delivery_count = 0
    delivery_ready = 0.0
    deliveries_spawned = 0
    birthday_id = -1
    birthday_seated = false
    birthday_served = false
    vip_served_final = false
    reservation_spawned = false
    dirty_max = 0
    selected_recipe = -1
    selected_toppings.clear()
    if song_label != null: reset_music_state()

func new_party() -> Dictionary:
    # Alpha 12.72 party sizes, zero-indexed campaign levels:
    # Days 1-2: singles and couples only; opening party fits a two-seat table.
    # Day 3: introduce both 3- and 4-person parties, guaranteed in this roster.
    # Days 4-5: progressively more 3- and 4-person parties.
    # Days 6+ retain the established distribution (Day 7 cycles 1/2/3/4).
    var roll: float = rng.randf()
    var size: int = 2
    if not endless_mode and current_level < 2:
        if next_party_id == 0:
            size = 2
        else:
            size = 1 if roll < (0.35 if current_level == 0 else 0.25) else 2
    elif not endless_mode and current_level == 2:
        if next_party_id == 2:
            size = 3
        elif next_party_id == 6:
            size = 4
        else:
            size = 1 if roll < 0.15 else (2 if roll < 0.70 else (3 if roll < 0.92 else 4))
    elif not endless_mode and current_level == 3:
        size = 1 if roll < 0.12 else (2 if roll < 0.55 else (3 if roll < 0.82 else 4))
    elif not endless_mode and current_level == 4:
        size = 1 if roll < 0.10 else (2 if roll < 0.40 else (3 if roll < 0.70 else 4))
    elif current_level == 6:
        size = [1, 2, 3, 4][next_party_id % 4]
    else:
        size = 1 if roll < 0.15 else (2 if roll < 0.55 else (3 if roll < 0.83 else 4))
    # Never generate an unseatable 3/4-person party when every table is yellow.
    # The first red conversion immediately unlocks big parties (Day 3+).
    if not has_red_table():
        size = mini(size, 2)
    var party := {"id":next_party_id, "size":size, "patience":starting_queue_patience(), "color":SHIRTS[next_party_id % SHIRTS.size()], "vip":next_party_id > 0 and next_party_id % int(cfg("vip_every")) == 0, "pizza":rng.randi_range(0,2), "toppings": []}
    # Starting patience is calibrated to real queue seconds, not raw points.
    party["patience_bar_max"] = party["patience"]
    # One topping from Days 6–10, two from Days 11–15, three from Days 16–20.
    # Days 1–5 retain standard pizzas with no ingredient-selection popup.
    # Mixed menu: customers can order a simple cheese pizza without a popup.
    # Custom ingredient orders are more common during their introduction.
    var custom_chance: float = 0.75 if current_level < 10 else (0.65 if current_level < 15 else 0.60)
    var custom_order: bool = current_level >= 5 and (next_party_id == 0 or rng.randf() < custom_chance)
    party["custom_order"] = custom_order
    if custom_order:
        var ingredient_count: int = 1 if current_level < 10 else (2 if current_level < 15 else 3)
        var available: int = 3 if current_level < 13 else CHEF_NAMES.size()
        var pool: Array[int] = []
        for k in range(available): pool.append(k)
        pool.shuffle()
        var order_ingredients: Array[int] = []
        for k in range(ingredient_count): order_ingredients.append(pool[k])
        party["toppings"] = order_ingredients
    # Level 7 introduces double pizza orders; Level 8 reinforces them.
    # Not every table orders two; the rule continues in later levels.
    party["pizzas_left"] = 2 if has_double_pizza_order() and next_party_id % 4 == 1 else 1
    party["pizzas_total"] = party["pizzas_left"]
    party["double_dishes"] = has_double_dishes() and next_party_id % 3 == 2
    next_party_id += 1
    guests_arrived_this_shift += size
    return party

func plan_party_arrivals() -> void:
    party_arrival_times.clear()
    next_arrival_slot = 0
    # Birthday reservation is explicitly scheduled and counts toward the cap.
    var special_count: int = 1 if mode() in ["reservation", "final"] else 0
    var normal_count: int = maxi(0, int(cfg("party_cap")) - special_count)
    if normal_count == 0:
        return
    # One party at opening; others trickle in throughout the shift.
    # Modest jitter avoids a mechanical one-party-every-N-seconds pattern.
    party_arrival_times.append(0.0)
    var available_window: float = float(cfg("time")) * 0.89
    var step: float = available_window / float(maxi(1, normal_count - 1))
    for i in range(1, normal_count):
        var planned: float = float(i) * step
        var random_offset: float = rng.randf_range(-step * 0.26, step * 0.26)
        var next_time: float = clampf(planned + random_offset, 0.0, available_window)
        # Prevent overlapping arrivals while still allowing occasional mini-rushes.
        next_time = maxf(next_time, party_arrival_times[-1] + minf(1.5, step * 0.40))
        party_arrival_times.append(minf(next_time, float(cfg("time")) * 0.92))

func start_game() -> void:
    hide_level_complete_ui()
    hide_level_failed_ui()
    if expansion_gate_message() != "":
        try_start_game()
        return
    campaign_win = false
    reset_music_state()
    prepare_scene()
    plan_party_arrivals()
    playtest_last_table_states.clear()
    playtest_last_table_parties.clear()
    playtest_last_queue_ids.clear()
    playtest_last_action_click_ms = -1
    playtest_record("shift_started", {"party_cap":int(cfg("party_cap")), "shift_time_limit":float(cfg("time")), "goal":int(cfg("goal")), "mode": "endless" if endless_mode else "campaign", "wave": endless_wave if endless_mode else 0, "upgrades":owned_upgrades.duplicate()})
    # Opening customer appears at the door; subsequent parties follow the schedule.
    if not party_arrival_times.is_empty():
        queue.append(new_party())
        next_arrival_slot = 1
    running = true
    shift_paused = false
    chef_popup_hidden_for_pause = false
    if pause_overlay != null: pause_overlay.hide()
    if pause_button != null: pause_button.show()
    finished = false
    if shop_open:
        toggle_shop()
    start_panel.hide()
    if campaign_screens != null: campaign_screens.hide_screens()
    if stage_panel != null: stage_panel.hide()
    if not music_muted: music_players[music_active_player].play()
    message = "Select group & table; tap table to TAKE ORDER, then tap ORDER DISH at kitchen."
    if current_level == 0 and not tutorial_seen and tutorials_enabled:
        tutorial_step = 0
        show_tutorial_step()
    update_ui()
    queue_redraw()

func end_game(success: bool) -> void:
    if finished: return
    tutorial_waiting = false
    tutorial_step = -1
    if tutorial_skip_button != null: tutorial_skip_button.hide()
    playtest_snapshot()
    playtest_record("shift_finished", {"success":success, "shift_cash_final":cash, "served_final":served, "lost_final":lost, "correct_pizzas":correct_count, "wrong_pizzas_final":wrong_count})
    running = false
    shift_paused = false
    chef_popup_hidden_for_pause = false
    if pause_overlay != null: pause_overlay.hide()
    if pause_button != null: pause_button.hide()
    action_queue.clear()
    for p in music_players: p.stop()
    finished = true
    campaign_win = success
    var wallet_before_shift: int = wallet_coins
    var level_key: String = ("endless_%d" % endless_wave) if endless_mode else str(current_level)
    var rush_bonus: int = 0
    if success and is_rush_day():
        rush_bonus = 10 + (5 if lost == 0 else 0) + (5 if lost == 0 and wrong_count == 0 else 0)
    var gross_payout: int = cash + rush_bonus
    var previous_best: int = int(endless_record_payout.get(level_key, 0)) if endless_mode else int(best_level_payout.get(level_key, 0))
    # Failed attempts never pay campaign coins. Only a successful new best
    # earns its incremental difference. No replay farming on worse outcomes.
    var wallet_gain: int = maxi(0, gross_payout - previous_best) if success else 0
    if success and endless_mode:
        endless_record_payout[level_key] = maxi(previous_best, gross_payout)
        endless_best_wave = maxi(endless_best_wave, endless_wave)
        competition_hub.record_endless_round(endless_best_wave)
        endless_best_cash = maxi(endless_best_cash, cash)
    if success and not endless_mode:
        best_level_payout[level_key] = maxi(previous_best, gross_payout)
        best_walkouts[level_key] = mini(int(best_walkouts.get(level_key, lost)), lost)
    lifetime_coins += wallet_gain
    wallet_coins += wallet_gain
    playtest_record("review_and_replay", {"day":current_level + 1, "walkouts":lost, "best_walkouts":int(best_walkouts.get(level_key, -1)), "rating":overall_review_stars(), "shift_payout":gross_payout, "previous_best":previous_best, "wallet_gain":wallet_gain})
    if rush_bonus > 0:
        playtest_record("rush_bonus", {"day":current_level+1,"bonus_coins":rush_bonus})
    total_guests_served += served
    total_pizzas_served += correct_count
    if success:
        total_completed_days += 1
        if lost == 0 and wrong_count == 0:
            total_perfect_days += 1
    _save_progress()
    shop_button.show()
    start_panel.show()
    if stage_select_button != null: stage_select_button.show()
    panel_title.text = "LEVEL %d COMPLETE!" % (current_level + 1) if success else "LEVEL %d - TRY AGAIN" % (current_level + 1)
    if level_failed_select_button != null:
        level_failed_select_button.visible = not success and not endless_mode
    if endless_mode:
        retry_button.disabled = false
        retry_button.mouse_filter = Control.MOUSE_FILTER_STOP
        panel_title.text = "ENDLESS ROUND %d CLEARED!" % endless_wave if success else "ENDLESS ROUND %d FAILED" % endless_wave
        panel_description.text = "%s\n\nEarned: %d coins (best-run improvement only)\nServed: %d   Walkouts: %d\nBest cleared round: %d\n\n%s" % [str(cfg("name")), wallet_gain, served, lost, endless_best_wave, "Next: try the harder round." if success else "Try this round again. No purchases required."]
        retry_button.text = "NEXT ENDLESS ROUND ▶" if success else "RETRY ENDLESS ROUND"
        retry_button.show()
        start_button.hide()
        update_ui()
        return
    if success:
        var stars_now: int = earned_stars(true)
        best_stars[level_key] = maxi(int(best_stars.get(level_key, 0)), stars_now)
        best_cash[level_key] = maxi(int(best_cash.get(level_key, 0)), cash)
        _save_progress()
        if current_level < LEVELS.size() - 1:
            highest_unlocked = maxi(highest_unlocked, current_level + 1)
            _save_progress()
            panel_description.text = "SAVED COINS: %d + %d = %d\n\n%s\n\n%s  •  %d guests served  •  $%d earned\n%d walkouts   |   Personal best: $%d\n\nNEXT: DAY %d - %s" % [wallet_before_shift, wallet_gain, wallet_coins, str(cfg("name")), "★".repeat(stars_now) + "☆".repeat(3 - stars_now), served, cash, lost, int(best_cash[level_key]), current_level + 2, str(LEVELS[current_level + 1]["name"])]
            retry_button.text = "PLAY NEXT DAY %d ▶" % (current_level + 2)
        else:
            panel_description.text = "CHAPTER COMPLETE!\n\nSAVED COINS: %d + %d = %d\n\n%s  •  You completed all 100 days!\n%d guests served    $%d earned\nPizza Legend complete!" % [wallet_before_shift, wallet_gain, wallet_coins, "★".repeat(stars_now) + "☆".repeat(3 - stars_now), served, cash]
            retry_button.text = "REPLAY LEVEL 100"
    else:
        panel_description.text = "SAVED COINS: %d + %d = %d\n\n%s\n\n%d guests served    $%d / $%d earned\n%d parties left unhappy\n\nSeat groups efficiently and try again!" % [wallet_before_shift, wallet_gain, wallet_coins, str(cfg("name")), served, cash, int(cfg("goal")), lost]
        retry_button.text = "RETRY LEVEL %d" % (current_level+1)
    if success:
        panel_description.text += "\nREPLAY: Previous best %d, this run %d, wallet gain +%d coins." % [previous_best, gross_payout, wallet_gain]
        panel_description.text += "\nRESTAURANT REVIEW: %s  |  Best walkouts on Day %d: %d" % [review_text(), current_level + 1, int(best_walkouts[level_key])]
    if lost > 0:
        panel_description.text += "\n\n★ REPLAY TO RECOVER STARS: Improve this day's walkout record to regain 1/3 review star per avoided walkout. Your best result is kept; no extra star rewards are added."
    if rush_bonus > 0:
        panel_description.text += "\n🔥 RUSH DAY BONUS: %d COINS (included in day score; only best-score improvement is paid)" % rush_bonus
    if success and current_level == 99:
        panel_description.text += "\n\nCAMPAIGN COMPLETE! Play the Day 100 championship mini-game and unlock Endless Restaurant. Review goal: 4 / 5 stars."
    start_button.hide()
    retry_button.show()
    retry_button.disabled = false
    retry_button.mouse_filter = Control.MOUSE_FILTER_STOP
    retry_button.grab_focus()
    update_ui()
    # Suggest optional purchases when they are affordable; never force one.
    if success and not endless_mode and (current_level + 1) % 5 == 0:
        milestone_bonus_button.text = "PLAY DAY %d MINI-GAME" % (current_level + 1)
        milestone_bonus_button.show()
        if not competition_hub.already_seen(current_level + 1):
            pending_bonus_day_after_results = current_level + 1
    else:
        milestone_bonus_button.hide()
    # Completion is never obscured by a shop prompt or an automatic mini-game.
    # The same prompts are offered after the player presses Next Level.
    if success and not endless_mode:
        show_level_complete_ui(earned_stars(true), wallet_gain, served, guests_arrived_this_shift)
    elif not success and not endless_mode:
        show_level_failed_ui(wallet_gain, served, guests_arrived_this_shift)

func update_robot(dt: float) -> void:
    if not has_upgrade("robot") or current_level < 15:
        return
    if not robot_busy:
        robot_pickup_delay = maxf(0.0, robot_pickup_delay - dt)
        if robot_pickup_delay > 0.0:
            return
        robot_targets.clear()
        robot_target_index = 0
        var capacity: int = 2 if has_upgrade("robot_capacity") else 1
        for i in range(tables.size()):
            if robot_targets.size() >= capacity:
                break
            if str(tables[i]["state"]) == "ready":
                tables[i]["state"] = "robot_in_transit"
                robot_targets.append(i)
        if robot_targets.is_empty():
            return
        robot_busy = true
        add_float(Vector2(1120, 340), "ROBOT PICKUP!")
    if robot_target_index >= robot_targets.size():
        robot_busy = false
        robot_targets.clear()
        robot_pickup_delay = 0.6
        return
    var target: int = robot_targets[robot_target_index]
    if target < 0 or target >= tables.size() or str(tables[target]["state"]) != "robot_in_transit":
        robot_target_index += 1
        return
    var destination: Vector2 = TABLE_POS[target] + Vector2(65, 46)
    var speed: float = 390.0 * (1.30 if has_upgrade("robot_speed") else 1.0)
    var delta_pos: Vector2 = destination - robot_pos
    if delta_pos.length() <= speed * dt + 3.0:
        robot_pos = destination
        deliver_cooked_pizza(target, true)
        robot_target_index += 1
    else:
        robot_pos += delta_pos.normalized() * speed * dt

func _process(delta: float) -> void:
    if intro_active:
        update_cinematic_intro(delta)
        return
    if toss_active:
        toss_remaining = maxf(0.0, toss_remaining - delta)
        toss_phase += delta * 4.2
        update_toss_labels()
        if toss_remaining <= 0.0:
            finish_pizza_toss()
        return
    if shift_paused:
        return
    if shop_open:
        queue_redraw()
        return
    if not running:
        queue_redraw()
        return
    var dt: float = minf(delta, 0.07)
    chef_walk_remaining = maxf(0.0, chef_walk_remaining - dt)
    chef_oven_in_remaining = maxf(0.0, chef_oven_in_remaining - dt)
    chef_oven_out_remaining = maxf(0.0, chef_oven_out_remaining - dt)
    tutorial_anim_time += dt
    # During first-day teaching, movement and cooking still work, but all
    # customer clocks and arrivals remain frozen until the tutorial ends.
    var clock_dt: float = 0.0 if current_level == 0 and tutorial_step >= 0 and not tutorial_seen else dt
    elapsed += clock_dt
    if remaining > 0.0:
        remaining = maxf(0.0, remaining - clock_dt)
    else:
        # The doors are closed: existing guests may still finish eating and paying.
        # After the door closes, service continues without any forced timeout.
        if not closing_announced:
            closing_announced = true
            message = "CLOSED TO NEW CUSTOMERS! Finish seating and serving everyone waiting."
    update_robot(dt)
    music_tick(dt)
    spawn_clock += clock_dt
    if clock_dt > 0.0 and remaining > 0.0 and mode() in ["reservation", "final"] and not reservation_spawned and elapsed >= minf(25.0, float(cfg("time")) * 0.5) and remaining_parties_to_arrive() > 0:
        reservation_spawned = true
        var party: Dictionary = new_party()
        party["size"] = 4 if has_red_table() else 2
        party["birthday"] = true
        party["patience"] = starting_queue_patience()
        party["patience_bar_max"] = party["patience"]
        birthday_id = int(party["id"])
        queue.push_front(party)
        launch_music_event("party")
        message = "BIRTHDAY PARTY OF FOUR ARRIVED! Save a 4-seat table!" if has_red_table() else "BIRTHDAY RESERVATION OF TWO ARRIVED! Convert a yellow table to red for larger groups."
    # Natural arrivals: one party at opening, then irregularly staggered groups.
    # No party arrives after closing or beyond the day's fixed party limit.
    # Unlike previous deterministic slots, the timetable is made once at start.
    while clock_dt > 0.0 and remaining > 0.0 and next_arrival_slot < party_arrival_times.size() and elapsed >= party_arrival_times[next_arrival_slot] and remaining_parties_to_arrive() > 0:
        queue.append(new_party())
        next_arrival_slot += 1
    # Arrival roster is full once every scheduled party is created; stop
    # admissions even if the countdown still has time remaining.
    if remaining_parties_to_arrive() == 0 and not shift_roster_closed:
        shift_roster_closed = true
        message = "LAST PARTY ARRIVED! No new customers. Finish serving your guests."
    # Execute the oldest queued tap as soon as the waitress is available.
    # Resolve table state at execution time so newly-ready orders can be collected.
    if task_table == -1 and not action_queue.is_empty():
        var next_action: Vector2 = action_queue.pop_front()
        handle_click(next_action)
    waitress_is_walking = false
    if task_table != -1:
        var offset := waitress_destination - waitress_pos
        if offset.length() > 4.0:
            waitress_is_walking = true
            waitress_walk_time += dt
            if absf(offset.x) > 1.0:
                waitress_facing_left = offset.x < 0.0
        if offset.length() < 650.0 * dt + 4.0:
            waitress_pos = waitress_destination
            complete_task()
        else:
            waitress_pos += offset.normalized() * 650.0 * dt
    # Queued parties keep losing patience even when all tables are full or
    # the restaurant's arrivals timer has reached zero. Only Pause freezes dt.
    for i in range(queue.size() - 1, -1, -1):
        queue[i]["patience"] -= clock_dt * effective_patience_decay(float(cfg("queue_decay"))) * (0.75 if has_upgrade("entertainer") else 1.0)
        if queue[i]["patience"] <= 0.0:
            queue.remove_at(i)
            selected_party = -1
            lost += 1
            chain = 0
            message = "REVIEW -1/3 STAR! Replay this day with fewer walkouts to recover lost stars."
    for i in range(tables.size()):
        var table: Dictionary = tables[i]
        if table["state"] in ["deciding", "cooking", "eating"]:
            table["timer"] -= dt
            if table["timer"] <= 0.0:
                if table["state"] == "deciding":
                    table["state"] = "order"
                    table["party"]["ready_to_order_at"] = elapsed
                    add_float(TABLE_POS[i], "READY TO ORDER!")
                else:
                    var finished_eating: bool = table["state"] == "eating"
                    table["state"] = "ready" if not finished_eating else "pay"
                    if not finished_eating:
                        # Animate the chef turning with a finished pizza; do not alter table state.
                        chef_oven_out_remaining = CHEF_OVEN_OUT_SECONDS
                        table["pizza_ready_at"] = elapsed
                        playtest_record("pizza_ready_for_pickup", {"table":i + 1, "at_seconds":elapsed})
                        tutorial_advance(5)
                    if finished_eating:
                        table["party"]["payment_ready_at"] = elapsed
                        table["party"]["tip_patience_at_ready"] = maxf(0.0, float(table["party"].get("patience", 0.0)))
                    add_float(TABLE_POS[i], "PIZZA READY!" if table["state"] == "ready" else "PAYMENT!")
        if table["state"] in ["dirty", "dishes_collected"]:
            var dirty_now: int = 0
            for t in tables:
                if t["state"] in ["dirty", "dishes_collected"]: dirty_now += 1
            dirty_max = maxi(dirty_max, dirty_now)
        var seated_party: Dictionary = table["party"]
        if not seated_party.is_empty():
            var decay := (1.15 if current_level >= 5 and current_level <= 9 else 1.5) if table["state"] in ["order", "ticket", "ready", "collected", "robot_in_transit", "pay"] else 0.3
            table["party"]["patience"] -= clock_dt * effective_patience_decay(decay * float(cfg("table_decay")))
            if table["party"]["patience"] <= 0.0:
                # A party that has finished eating but waits too long to pay
                # walks out without paying or tipping, and leaves dirty dishes.
                var previous_state: String = str(table["state"])
                var left_before_ordering: bool = previous_state in ["deciding", "order"]
                var left_after_meal: bool = previous_state == "pay"
                var departing_party: Dictionary = table["party"]
                held_tickets.erase(i)
                carried_pizzas.erase(i)
                chef_pending_tables.erase(i)
                chef_saved_selections.erase(i)
                if chef_active_table == i:
                    chef_overlay.hide()
                    chef_active_table = -1
                    chef_selected.clear()
                table["party"] = {}
                table["state"] = "empty" if left_before_ordering else "dirty"
                table["clean_left"] = (2 if bool(departing_party.get("double_dishes", false)) else 1) if left_after_meal else (0 if left_before_ordering else 1)
                table["timer"] = 0.0
                table["recipe_verified"] = false
                table["cooked_toppings"] = []
                lost += 1
                chain = 0
                if left_after_meal:
                    message = "REVIEW -1/3 STAR! No payment. Clean dishes; replay this day to recover lost stars."
                    playtest_record("unpaid_meal_walkout", {"table":i + 1, "party_id":int(departing_party.get("id", -1)), "dish_sets":int(table["clean_left"]), "coins":0})
                else:
                    message = "REVIEW -1/3 STAR! Replay this day to recover stars." if left_before_ordering else "REVIEW -1/3 STAR! Clean the table; replay to recover stars."
                add_float(TABLE_POS[i], "NO PAYMENT - DISHES" if left_after_meal else ("NO DISHES" if left_before_ordering else "PARTY LEFT"))
    for i in range(float_text.size() - 1, -1, -1):
        float_text[i]["age"] += dt
        if float_text[i]["age"] > 1.2: float_text.remove_at(i)
    for i in range(particles.size() - 1, -1, -1):
        particles[i]["pos"] += particles[i]["vel"] * dt
        particles[i]["vel"].y += 170.0 * dt
        particles[i]["age"] += dt
        if particles[i]["age"] > 0.9: particles.remove_at(i)
    hud_clock += dt
    if hud_clock > 0.15:
        hud_clock = 0.0
        playtest_snapshot()
        update_ui()
    queue_redraw()
    if running and lost >= 7:
        end_game(false)
    elif running:
        check_finish()
        # No overtime cutoff: player can seat, cook for, and collect from every guest.

func update_ui() -> void:
    # The simulation already reduces 'remaining' every tick. Display that
    # remaining time (rounded UP) rather than elapsed time or "CLOSING".
    var seconds_left: int = maxi(0, ceili(remaining))
    var countdown: String = "%02d:%02d" % [int(seconds_left / 60), seconds_left % 60]
    var seated_guests: int = 0
    for table in tables:
        if not (table.get("party", {}) as Dictionary).is_empty():
            seated_guests += int(table["party"].get("size", 0))
    if hud_counters.has("level"):
        (hud_counters["level"] as Label).text = "E%d" % endless_wave if endless_mode else str(current_level + 1)
        (hud_counters["clock"] as Label).text = countdown
        (hud_counters["coins"] as Label).text = str(cash)
        (hud_counters["stars"] as Label).text = "%.1f" % visible_review_stars()
        (hud_counters["guests"] as Label).text = str(seated_guests)
        for label in hud_counters.values():
            (label as Label).visible = running
    message_label.text = (message + ("  |  QUEUED: %d" % action_queue.size() if not action_queue.is_empty() else "")).substr(0, 120)

func _input(event: InputEvent) -> void:
    if event is InputEventMouseButton and event.pressed:
        playtest_record("raw_mouse_click", {"x":roundi(event.position.x), "y":roundi(event.position.y), "button":event.button_index, "ui_or_world":"raw", "paused":shift_paused})
    elif event is InputEventScreenTouch and event.pressed:
        playtest_record("raw_screen_touch", {"x":roundi(event.position.x), "y":roundi(event.position.y)})

func _unhandled_input(event: InputEvent) -> void:
    if shift_paused or tutorial_waiting or shop_open or not running or (chef_overlay != null and chef_overlay.visible): return
    if event is InputEventScreenTouch and event.pressed:
        last_touch_ms = Time.get_ticks_msec()
        last_touch_position = event.position
        queue_or_execute_tap(event.position)
    elif event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
        # Ignore the synthetic mouse event generated by the same finger tap.
        if Time.get_ticks_msec() - last_touch_ms < 350 and event.position.distance_to(last_touch_position) < 28.0:
            return
        queue_or_execute_tap(event.position)
    elif event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_BACKSPACE:
        if not action_queue.is_empty():
            action_queue.clear()
            message = "Planned actions cleared."
            playtest_record("planned_actions_cleared", {})
            update_ui()

func queue_or_execute_tap(point: Vector2) -> void:
    var click_ms: int = Time.get_ticks_msec()
    var since_previous_ms: int = click_ms - playtest_last_action_click_ms if playtest_last_action_click_ms >= 0 else -1
    playtest_last_action_click_ms = click_ms
    playtest_record("action_click_timing", {"x":roundi(point.x), "y":roundi(point.y), "ms_since_previous_action_click":since_previous_ms, "queued":task_table != -1 or not action_queue.is_empty(), "queue_depth":action_queue.size(), "active_task":task_type})
    # Tap-to-plan: don't discard taps while a waitress is travelling.
    # Queue table or kitchen stops in the exact order the player taps them.
    if task_table != -1 or not action_queue.is_empty():
        if action_queue.size() >= MAX_QUEUED_ACTIONS:
            message = "Action queue full. Wait for the waitress to complete a stop."
            return
        action_queue.append(point)
        message = "Planned stop %d/%d. Backspace clears planned stops." % [action_queue.size(), MAX_QUEUED_ACTIONS]
        update_ui()
    else:
        handle_click(point)

func move_to_station(station: String, table_id: int) -> void:
    task_table = -2
    task_type = station
    task_party_id = table_id
    waitress_destination = Vector2(1050, 413) if station == "submit_ticket" else (Vector2(1050, 365) if station == "pickup_pizza" else Vector2(1050, 481))
    message = "Waitress walking to %s..." % ({"submit_ticket":"ORDER DISH", "pickup_pizza":"PIZZA PICKUP", "drop_dishes":"DISHWASHING STATION"}.get(station,"STATION"))

func station_click(point: Vector2) -> bool:
    # Each station handles a batch of up to two linked tasks in one trip.
    if task_table != -1:
        if Rect2(1003, 302, 268, 201).has_point(point):
            message = "Wait for the waitress to finish walking before starting another station task."
            return true
    if Rect2(1003, 458, 268, 45).has_point(point):
        if pending_cleaning.is_empty():
            message = "Collect dirty dishes first (cart holds %d pickups)." % dish_cart_capacity()
        else:
            move_to_station("drop_dishes", pending_cleaning[0])
        return true
    if Rect2(1003, 380, 268, 78).has_point(point):
        if current_level >= 5 and not chef_pending_tables.is_empty():
            open_next_chef_ticket()
            return true
        if held_tickets.is_empty():
            message = "Take up to TWO table orders before visiting ORDER DISH."
        else:
            move_to_station("submit_ticket", held_tickets[0])
        return true
    if Rect2(1003, 302, 268, 74).has_point(point):
        if carried_pizzas.size() >= (4 if has_upgrade("tray") else 2):
            message = "Your hands/tray are full. Deliver a pizza before collecting more."
            return true
        var ready_table: int = -1
        for n in range(tables.size()):
            if str(tables[n]["state"]) == "ready":
                ready_table = n
                break
        if ready_table < 0:
            message = "No pizzas ready at the pickup bar yet."
        else:
            move_to_station("pickup_pizza", ready_table)
        return true
    return false

func handle_click(point: Vector2) -> void:
    if station_click(point): return
    if point.x >= 1005.0 and point.y >= 500.0 and point.y < 635.0:
        if mode() == "ingredients" and current_level < 5:
            var number: int = clampi(int((point.x - 1020.0) / 60.0), 0, 3)
            if number in selected_toppings: selected_toppings.erase(number)
            else: selected_toppings.append(number)
            message = "TOPPINGS: " + str(selected_toppings) + " (tap READY table to submit)"
            return
        if mode() in ["correct", "final"]:
            selected_recipe = clampi(int((point.x-1020.0) / 76.0), 0, 2)
            message = "Selected pizza: " + PIZZA_TYPES[selected_recipe]
            return
    for i in range(queue.size()):
        var p := Vector2(104.0, 185.0 + i * 116.0)
        if point.distance_to(p) < 60.0:
            selected_party = i
            if tutorial_step == 0: tutorial_advance(1)
            message = "Party of %d selected. Choose a %d+ seat table." % [queue[i]["size"], queue[i]["size"]]
            update_ui()
            return
    for i in range(tables.size()):
        if point.distance_to(TABLE_POS[i]) < 95.0:
            handle_table(i)
            return

func handle_table(i: int) -> void:
    if task_table != -1:
        message = "Wait for the waitress to finish her current task."
        return
    var t: Dictionary = tables[i]
    var state: String = t["state"]
    if state == "empty":
        if selected_party < 0 or selected_party >= queue.size():
            message = "First select a waiting party on the left!"
            return
        var party: Dictionary = queue[selected_party]
        if party["size"] > t["seats"]:
            message = "NOT ENOUGH CHAIRS! A party of %d needs a 4-seat table." % party["size"]
            add_float(TABLE_POS[i], "TOO SMALL!")
            return
        task_party_id = party["id"]
    else:
        task_party_id = -1
    if state == "dirty" and pending_cleaning.size() >= dish_cart_capacity():
        message = "Dish cart full (%d/%d). Drop dishes at the washing station." % [pending_cleaning.size(), dish_cart_capacity()]
        return
    if state == "dishes_collected":
        message = "Dishes already collected. Tap DISHWASHING STATION to clear this table."
        return
    if state == "ticket":
        message = "Order ticket held. Tap ORDER DISH to submit up to two tickets."
        return
    if state == "ready":
        message = "Pizza is waiting at the PICKUP BAR! Collect it there first."
        return
    if state == "collected" and i not in carried_pizzas:
        message = "Pick up this table's pizza at the bar first."
        return
    if state == "order" and held_tickets.size() >= 2:
        message = "Order tray full (2/2). Submit tickets to ORDER DISH first."
        return
    if state == "deciding":
        message = "Customers are choosing their pizza. Come back when their order is ready."
        return
    if state == "chef_wait":
        open_chef_ticket_for_table(i)
        return
    if state in ["cooking", "eating", "robot_in_transit"]:
        message = "Give them a moment! Try another table."
        return
    task_table = i
    task_type = state
    waitress_destination = TABLE_POS[i] + Vector2(95, 50)
    message = "Waitress walking to table %d..." % (i + 1)

func complete_task() -> void:
    var i := task_table
    var state := task_type
    playtest_record("task_completed", {"table":i+1 if i >= 0 else -1, "task":state, "queue_depth":action_queue.size(), "ms_since_last_action_click":Time.get_ticks_msec() - playtest_last_action_click_ms if playtest_last_action_click_ms >= 0 else -1})
    task_table = -1
    if i == -2:
        if state == "drop_dishes":
            var batch: Array[int] = pending_cleaning.duplicate()
            pending_cleaning.clear()
            var cleaned: int = 0
            for n in batch:
                if str(tables[n]["state"]) == "dishes_collected":
                    tables[n]["clean_left"] = maxi(0, int(tables[n].get("clean_left", 1)) - 1)
                    tables[n]["state"] = "dirty" if int(tables[n]["clean_left"]) > 0 else "empty"
                    clean_count += 1
                    cleaned += 1
            message = "Washed %d set(s) of dishes! Tables are ready for new guests." % cleaned
            if cleaned > 0: tutorial_advance(10)
            add_float(Vector2(1125, 481), "DISHES CLEAN!")
            check_finish()
        elif state == "submit_ticket":
            var batch: Array[int] = held_tickets.duplicate()
            held_tickets.clear()
            for n in batch:
                if str(tables[n]["state"]) == "ticket":
                    if current_level >= 5 and bool(tables[n]["party"].get("custom_order", false)):
                        tables[n]["state"] = "chef_wait"
                        if n not in chef_pending_tables:
                            chef_pending_tables.append(n)
                    else:
                        # Simple pizza: no ingredient popup or manual selection.
                        tables[n]["cooked_toppings"] = []
                        tables[n]["recipe_verified"] = true
                        tables[n]["state"] = "cooking"
                        tables[n]["timer"] = (3.0 if has_upgrade("oven") else 5.0 * float(cfg("cook")))
            message = "%d order ticket(s) submitted to the chef." % batch.size()
            tutorial_advance(4)
            open_next_chef_ticket()
            add_float(Vector2(1115, 414), "TICKETS SENT!")
        elif state == "pickup_pizza":
            var count: int = 0
            for n in range(tables.size()):
                if carried_pizzas.size() >= (4 if has_upgrade("tray") else 2): break
                if str(tables[n]["state"]) == "ready":
                    tables[n]["state"] = "collected"
                    carried_pizzas.append(n)
                    count += 1
            var collected_table_names: Array[String] = []
            for carried_id in carried_pizzas:
                collected_table_names.append("T%d" % (carried_id + 1))
            if count > 0: tutorial_advance(6)
            message = "Picked up %d pizza(s) for %s. Deliver to their numbered tables." % [count, ", ".join(collected_table_names)]
            add_float(Vector2(1125, 356), "PIZZA PICKUP!")
        return
    task_type = ""
    var t: Dictionary = tables[i]
    if t["state"] != state: return
    match state:
        "empty":
            var idx := -1
            for k in range(queue.size()):
                if queue[k]["id"] == task_party_id:
                    idx = k
                    break
            if idx < 0:
                message = "That party left before being seated."
                return
            var party: Dictionary = queue[idx]
            # Seating reward: increase remaining patience by 50% once per party.
            # This is multiplicative, not a reset to the starting patience.
            var old_patience: float = float(party["patience"])
            var seated_patience: float = old_patience * 1.5
            party["patience"] = seated_patience
            party["patience_bar_max"] = maxf(float(party.get("patience_bar_max", 100.0)), seated_patience)
            t["party"] = party
            playtest_record("party_seated", {"party_id":int(party.get("id", -1)), "patience_before":old_patience, "patience_after":seated_patience, "seating_bonus_percent":50})
            add_float(TABLE_POS[i], "+50% SEATING PATIENCE!")
            # Guests take four seconds after being seated to decide what to order.
            t["state"] = "deciding"
            t["timer"] = 4.0
            if int(party["size"]) >= 3: big_parties += 1
            if int(party["id"]) == birthday_id: birthday_seated = true
            queue.remove_at(idx)
            selected_party = -1
            tutorial_advance(2)
            if music_event.is_empty():
                if bool(party["vip"]): launch_music_event("vip")
                elif int(party["size"]) >= 3: launch_music_event("family")
                elif mode() in ["large", "clean", "correct"]: launch_music_event("romance")
            if party["size"] == t["seats"]:
                cash += 5
                add_float(TABLE_POS[i], "+$5 PERFECT FIT")
            message = "Seated %d guests! +50%% remaining patience; 4 seconds to choose a pizza." % [party["size"]]
        "order":
            # Fast order bonus: collect the ticket within 3 seconds of READY TO ORDER.
            # Increase remaining patience by 25%, once per party (not 25 points).
            var ordering_party: Dictionary = t["party"]
            var ready_at: float = float(ordering_party.get("ready_to_order_at", -9999.0))
            var order_response_seconds: float = elapsed - ready_at
            if not bool(ordering_party.get("fast_service_bonus_used", false)) and order_response_seconds >= 0.0 and order_response_seconds <= 3.0:
                ordering_party["fast_service_bonus_used"] = true
                apply_quick_patience_bonus(ordering_party, i, "ORDER")
                playtest_record("fast_order_reward", {"table":i + 1, "response_seconds":order_response_seconds})
            ordering_party["order_taken_at"] = elapsed
            t["state"] = "ticket"
            held_tickets.append(i)
            tutorial_advance(3)
            message = "Order ticket collected (%d/2). Take another or tap ORDER DISH." % held_tickets.size()
        "collected":
            if needs_accuracy() and current_level < 5:
                var party: Dictionary = t["party"]
                var accurate: bool = false
                if mode() == "ingredients":
                    var wanted: Array = party["toppings"]
                    accurate = selected_toppings.size() == wanted.size()
                    for topping in wanted:
                        if topping not in selected_toppings: accurate = false
                    selected_toppings.clear()
                else:
                    accurate = selected_recipe == int(party["pizza"])
                    selected_recipe = -1
                if not accurate:
                    wrong_count += 1
                    chain = 0
                    message = "WRONG PIZZA! Correct your selection, then tap this table again."
                    if wrong_count > 1 and mode() in ["correct", "final"]: end_game(false)
                    return
                correct_count += 1
            carried_pizzas.erase(i)
            deliver_cooked_pizza(i)
            tutorial_advance(7)
        "pay":
            var party: Dictionary = t["party"]
            # Payment is immediate if collected within five seconds of the
            # customer finishing their meal. Bonus affects the tip calculation.
            if not bool(party.get("quick_payment_bonus_used", false)) and elapsed - float(party.get("payment_ready_at", -9999.0)) <= 5.0:
                party["quick_payment_bonus_used"] = true
                apply_quick_patience_bonus(party, i, "PAYMENT")
            # Normalize shift earnings by the scheduled party count rather than
            # by party size, so all 20 days earn roughly 100 coins on a good run.
            # A perfect, uninterrupted shift can earn about 120 coins.
            # Snapshot patience when the meal finishes. Waiting for the waitress
            # to collect payment cannot further lower the tip.
            var tip_patience: float = float(party.get("tip_patience_at_ready", party.get("patience", 0.0)))
            var patience_fraction: float = clampf(tip_patience / 100.0, 0.0, 1.0)
            var party_count: float = float(maxi(1, int(cfg("party_cap"))))
            # Keep the established base and tip amounts. Only the tip is scaled
            # when patience at payment-ready drops below 25 seconds.
            var base_payment: float = (75.0 if current_level >= 8 else 90.0) / party_count
            var full_tip: float = (45.0 if current_level >= 8 else 30.0) * patience_fraction / party_count
            var tip_multiplier: float = clampf(tip_patience / 25.0, 0.0, 1.0)
            var earned_tip: float = full_tip * tip_multiplier
            var payment: int = maxi(1, roundi(base_payment + earned_tip))
            if bool(party["vip"]): payment += 1
            playtest_record("payment_collected", {"table":i+1, "party_id":int(party.get("id", -1)), "party_size":int(party["size"]), "patience_remaining":snappedf(float(party["patience"]), 0.01), "tip_patience_at_ready":snappedf(tip_patience, 0.01), "tip_multiplier":snappedf(tip_multiplier, 0.01), "tip_amount":snappedf(earned_tip, 0.01), "coins":payment})
            cash += payment
            served += party["size"]
            chain += 1
            t["party"] = {}
            t["state"] = "dirty"
            t["clean_left"] = 2 if bool(party.get("double_dishes", false)) else 1
            music_on_payment(party)
            if party["vip"]:
                vip_count += 1
                vip_served_final = true
            if int(party["id"]) == birthday_id: birthday_served = true
            add_float(TABLE_POS[i], "+$%d" % payment)
            burst(TABLE_POS[i])
            message = "Collected $%d! Clean the table for the next party." % payment
            tutorial_advance(8)
            check_finish()
        "dirty":
            t["state"] = "dishes_collected"
            pending_cleaning.append(i)
            tutorial_advance(9)
            message = "Collected dirty dishes (%d/%d). Collect another or tap DISHWASHING STATION." % [pending_cleaning.size(), dish_cart_capacity()]
            add_float(TABLE_POS[i], "DISHES PICKED UP")

func add_float(p: Vector2, label: String) -> void:
    float_text.append({"pos":p, "label":label, "age":0.0})

func burst(p: Vector2) -> void:
    for i in range(22):
        var angle := rng.randf_range(0.0, TAU)
        particles.append({"pos":p,"vel":Vector2(cos(angle),sin(angle))*rng.randf_range(70,180),"age":0.0,"color":SHIRTS[i % SHIRTS.size()]})

func word(s: String, p: Vector2, size: int = 18, col: Color = DARK, center: bool = true) -> void:
    var font: Font = game_display_font if game_display_font != null else ThemeDB.fallback_font
    var sz := font.get_string_size(s, HORIZONTAL_ALIGNMENT_LEFT, -1, size)
    var x := p.x - sz.x / 2.0 if center else p.x
    draw_string(font, Vector2(x, p.y), s, HORIZONTAL_ALIGNMENT_LEFT, -1, size, col)

func rect(r: Rect2, color: Color, radius: float = 0) -> void:
    if radius <= 0:
        draw_rect(r, color)
    else:
        draw_rect(r, color)

func person(pos: Vector2, shirt: Color, scale_factor: float = 1.0, bounce: float = 0.0) -> void:
    var p := pos + Vector2(0, bounce)
    draw_ellipse_approx(p + Vector2(0, 24 * scale_factor), Vector2(16, 5) * scale_factor, Color(0,0,0,.18))
    draw_circle(p + Vector2(0, 14 * scale_factor), 15 * scale_factor, shirt)
    draw_circle(p + Vector2(0, -5 * scale_factor), 12 * scale_factor, Color("f7be91"))
    draw_arc(p + Vector2(0, -9 * scale_factor), 12 * scale_factor, PI, TAU, 10, Color("673d2b"), 5 * scale_factor)
    draw_circle(p + Vector2(-4,-5)*scale_factor, 1.2*scale_factor, DARK)
    draw_circle(p + Vector2(4,-5)*scale_factor, 1.2*scale_factor, DARK)

func draw_ellipse_approx(pos: Vector2, radii: Vector2, color: Color) -> void:
    var points := PackedVector2Array()
    for i in range(22):
        var a: float = TAU * float(i) / 22.0
        points.append(pos + Vector2(cos(a) * radii.x, sin(a) * radii.y))
    draw_colored_polygon(points, color)

func draw_table(index: int) -> void:
    var p: Vector2 = TABLE_POS[index]
    var t: Dictionary = tables[index]
    var seats: int = t["seats"]
    # Occupancy follows actual party data, never the cleaning/task state.
    # A cleaned/dirty table has an empty Dictionary and must not read party["size"].
    var party_data: Dictionary = t.get("party", {})
    var occupied: bool = not party_data.is_empty()
    var table_number: int = int(t.get("number", TABLE_NUMBERS[index]))
    # Draw guests at chair anchors BEFORE the table artwork so the tabletop
    # occludes their laps instead of making them appear to sit on the table.
    if occupied:
        var guest_count: int = int(party_data.get("size", 0))
        for k in range(guest_count):
            var side: float = -1.0 if k % 2 == 0 else 1.0
            var row: int = floori(float(k) / 2.0)
            var guest_center: Vector2 = p + Vector2(side * 86.0, -7.0 + float(row) * 26.0)
            if k == 0 and not customer_one_poses.is_empty():
                var pose: int = 8 if str(t["state"]) == "eating" else (3 if str(t["state"]) == "pay" else 0)
                draw_texture_rect(customer_one_poses[pose], Rect2(guest_center - Vector2(31, 80), Vector2(62, 98)), false)
            else:
                person(guest_center, party_data["color"], 0.58, sin(elapsed * 3 + k) * 1.5)
    if not draw_mapped_table(table_number, seats):
        # Fallback rectangle only if sprite cannot be loaded.
        draw_rect(Rect2(p-Vector2(62,40), Vector2(124,80)), Color("df4945") if seats == 4 else Color("f6d64a"))
    # Permanent number = location, independent of capacity or purchase order.
    
    # Table numbers remain internal identifiers; do not paint them on the table.

    if occupied:
        var party: Dictionary = party_data
        var pizza_label: String = "  |  %d PIZZAS" % int(party.get("pizzas_left", 1)) if int(party.get("pizzas_left", 1)) > 1 else ""
        word("%d GUESTS%s" % [party["size"], pizza_label],p+Vector2(0,6),15,Color("432f2b"))
        if needs_accuracy():
            var order_label: String = "TOP " + str(party["toppings"]) if current_level >= 5 and bool(party.get("custom_order", false)) else ("CLASSIC CHEESE" if current_level >= 5 else PIZZA_TYPES[int(party["pizza"])] )
            word(order_label,p+Vector2(0,27),13,BROWN)
    else:
        var dirty_label: String = "DISHES LEFT: %d" % int(t.get("clean_left", 1)) if t["state"] in ["dirty", "dishes_collected"] else ""
        word(dirty_label,p+Vector2(0,5),15,BROWN)
    var state: String = t["state"]
    var label: String = {"empty":"SEAT","deciding":"CHOOSING...","order":"TAKE ORDER","ticket":"TAKE TO DISH!","chef_wait":"SELECT TOPPINGS","cooking":"COOKING...","ready":"AT PICKUP BAR","collected":"DELIVER PIZZA!","eating":"EATING...","pay":"COLLECT CASH","dirty":"PICK UP DISHES","dishes_collected":"AT DISH STATION"}[state]
    var shade := Color("35965c") if state in ["empty","ready","collected"] else Color("bd7936")
    if state in ["dirty", "dishes_collected"]: shade=Color("796a65")
    if state == "pay": shade=Color("d3a02f")
    draw_rect(Rect2(p+Vector2(-69,52),Vector2(138,34)),shade)
    if state == "chef_wait" and occupied:
        label = "TAP: %d PIZZA%s LEFT" % [int(party_data.get("pizzas_left", 1)), "S" if int(party_data.get("pizzas_left", 1)) != 1 else ""]
    word(label,p+Vector2(0,75),17,Color.WHITE)
    if occupied:
        var pct: float = clampf(float(party_data.get("patience", 0.0))/maxf(0.01, float(party_data.get("patience_bar_max", 100.0))),0,1)
        var per_second_decay: float = (1.5 if state in ["order", "ticket", "ready", "collected", "robot_in_transit", "pay"] else 0.3) * float(cfg("table_decay"))
        var seconds_left: int = ceili(float(party_data.get("patience", 0.0)) / maxf(0.01, per_second_decay))
        var clock_color: Color = Color("e94a40") if pct <= 0.25 else (Color("edbe41") if pct <= 0.5 else Color("61b978"))
        word("CLOCK  %ds" % seconds_left, p + Vector2(0, 117), 16, clock_color)
        draw_rect(Rect2(p+Vector2(-65,91),Vector2(130,8)),Color("98785f"))
        draw_rect(Rect2(p+Vector2(-65,91),Vector2(130*pct,8)),Color("e94a40") if pct <= 0.25 else (Color("edbe41") if pct <= 0.5 else Color("61b978")))

func any_ready() -> bool:
    for t in tables:
        if str(t["state"]) == "ready": return true
    return false

func _draw() -> void:
    if restaurant_background != null:
        draw_texture_rect(restaurant_background, Rect2(0, 0, W, H), false)
    else:
        draw_rect(Rect2(0,0,W,H),FLOOR)
    # Legacy fallback floor styling when no replacement gameplay background exists.
    if restaurant_background == null:
        for y in range(85,645,54):
            for x in range(0,1280,54):
                draw_rect(Rect2(x,y,53,53),Color("f8dfb7") if ((x/54+y/54)%2)==0 else Color("eed0a4"))
        draw_rect(Rect2(0,79,211,570),Color("c98761"))
        draw_rect(Rect2(999,79,281,570),Color("b87850"))
        draw_rect(Rect2(0,0,1280,79),Color("59352d"))
        word("PIZZA PANIC!",Vector2(180,49),26,Color("ffe2a3"))
        
    if restaurant_background != null:
        word(str(wallet_coins), Vector2(482, 42), 23, Color("fff4da"))
        word(str(maxi(0, ceili(remaining))), Vector2(783, 42), 23, Color("fff4da"))
        word(str(served), Vector2(1110, 42), 23, Color("fff4da"))
        word(str(queue.size()), Vector2(1195, 42), 23, Color("fff4da"))
    word("WAITING PARTIES",Vector2(106,116),21,Color("fff4da"))
    word("ALPHA 13.39", Vector2(1165, 695), 13, Color("fff4da"))
    for i in range(4):
        var p := Vector2(106,185+i*116)
        draw_rect(Rect2(p-Vector2(88,45),Vector2(175,98)),Color(1.0, 0.95, 0.83, 0.86) if selected_party==i else Color(0.95, 0.80, 0.62, 0.75))
        if i >= queue.size():
            word("NEXT PARTY",p+Vector2(0,13),16,BROWN)
            continue
        var g:Dictionary = queue[i]
        for k in range(g["size"]):
            if k == 0 and not customer_one_poses.is_empty():
                draw_texture_rect(customer_one_poses[4], Rect2(p + Vector2((k-(g["size"]-1)/2.0)*35-22,-49), Vector2(44,70)), false)
            else:
                person(p+Vector2((k-(g["size"]-1)/2.0)*35,-13),g["color"],.68,sin(elapsed*3+k)*2)
        word("PARTY OF %d" % g["size"],p+Vector2(0,26),18,DARK)
        var queue_decay_rate: float = maxf(0.01, effective_patience_decay(float(cfg("queue_decay"))) * (0.75 if has_upgrade("entertainer") else 1.0))
        var seconds_waiting: int = maxi(0, ceili(float(g["patience"]) / queue_decay_rate))
        var pct:float=clampf(float(g["patience"])/maxf(0.01, float(g.get("patience_bar_max", 100.0))),0,1)
        word("WAIT  %ds" % seconds_waiting, p+Vector2(0,44),15,Color("a32e23") if pct<=0.25 else DARK)
        draw_rect(Rect2(p+Vector2(-74,46),Vector2(148,5)),Color("98785f"))
        draw_rect(Rect2(p+Vector2(-74,46),Vector2(148*pct,5)),Color("e94a40") if pct <= 0.25 else (Color("edbe41") if pct <= 0.5 else Color("61b978")))
    # decorative wall items
    for x in [295.0,665.0,937.0]:
        draw_circle(Vector2(x,105),13,Color("66a46c"))
        word("*",Vector2(x,112),26,Color("e1bb69"))
    # Decorative locked locations are not clickable or included in the table state array.
    for i in range(tables.size(), TABLE_NUMBERS.size()):
        var table_number: int = TABLE_NUMBERS[i]
        # Locked locations are yellow, until purchased and upgraded.
        draw_mapped_table(table_number, 2, true)
    for i in range(tables.size()):draw_table(i)
    for action_idx in range(action_queue.size()):
        var qpoint: Vector2 = action_queue[action_idx]
        for table_idx in range(tables.size()):
            if qpoint.distance_to(TABLE_POS[table_idx]) < 95.0:
                draw_circle(TABLE_POS[table_idx] + Vector2(71, -65), 20, Color("f3bf51"))
                word(str(action_idx + 1), TABLE_POS[table_idx] + Vector2(71, -58), 20, Color("432b21"))
                break
    # Kitchen transfer stations: ORDER DISH = submit ticket; PICKUP BAR = take ready pizza.
    draw_rect(Rect2(1005,302,267,73),Color(0.20, 0.54, 0.39, 0.82) if any_ready() else Color(0.40, 0.25, 0.18, 0.78))
    word("PIZZA PICKUP BAR",Vector2(1138,317),16,Color("fff6d8"))
    # Ready pizzas show the physical pickup assignment and cooked ingredients.
    # With several ready pizzas, cycle through batches so every label is visible.
    var pickup_labels: Array[String] = []
    for pickup_idx in range(tables.size()):
        var pickup_table: Dictionary = tables[pickup_idx]
        if str(pickup_table["state"]) != "ready":
            continue
        var pizza_label: String = ""
        if current_level >= 5:
            var cooked_ingredients: Array = pickup_table.get("cooked_toppings", [])
            var names: Array[String] = []
            for ingredient in cooked_ingredients:
                var ingredient_idx: int = int(ingredient)
                if ingredient_idx >= 0 and ingredient_idx < INGREDIENT_NAMES.size():
                    names.append(INGREDIENT_NAMES[ingredient_idx])
            pizza_label = "+".join(names) if not names.is_empty() else "CHEESE (CLASSIC)"
        else:
            pizza_label = PIZZA_TYPES[int(pickup_table["party"].get("pizza", 0))]
        pickup_labels.append("T%d: %s" % [pickup_idx + 1, pizza_label])
    if pickup_labels.is_empty():
        word("NO PIZZA READY",Vector2(1138,350),15,Color("fff3bb"))
    else:
        var page_start: int = (int(elapsed / 3.0) * 3) % pickup_labels.size()
        for display_idx in range(mini(3, pickup_labels.size())):
            var item_idx: int = (page_start + display_idx) % pickup_labels.size()
            word(pickup_labels[item_idx], Vector2(1138,336 + display_idx * 13), 12, Color("fff3bb"))
    draw_rect(Rect2(1005,380,267,74),Color("5184a3") if not held_tickets.is_empty() else Color("876453"))
    word("ORDER DISH",Vector2(1138,406),19,Color("fff6dc"))
    word("TAP: SEND %d/2 TICKETS" % held_tickets.size(),Vector2(1138,433),15,Color("fff3bb"))
    draw_rect(Rect2(1005,458,267,45),Color("6b998e") if not pending_cleaning.is_empty() else Color("87745f"))
    word("DISHWASHING",Vector2(1138,476),15,Color("fff6db"))
    word("TAP: DROP %d/%d DISHES" % [pending_cleaning.size(), dish_cart_capacity()],Vector2(1138,493),12,Color("fff3bb"))
    # kitchen artwork
    word("KITCHEN",Vector2(1140,120),28,Color("fff3ce"))
    if mode() in ["correct", "final"] and current_level < 5:
        word("CHOOSE PIZZA",Vector2(1140,515),16,Color("fff3ce"))
        for k in range(3):
            draw_rect(Rect2(1016 + k * 76,525,72,45),Color("61ab76") if selected_recipe == k else Color("ffdda4"))
            word(PIZZA_TYPES[k].substr(0,5),Vector2(1052+k*76,553),13,BROWN)
    if mode() == "ingredients" and current_level < 5:
        word("SELECT TOPPINGS",Vector2(1140,515),15,Color("fff3ce"))
        for k in range(4):
            draw_rect(Rect2(1018+k*60,525,55,45),Color("61ab76") if k in selected_toppings else Color("ffdda4"))
            word(INGREDIENT_NAMES[k].substr(0,4),Vector2(1045+k*60,553),13,BROWN)
    draw_rect(Rect2(1024,145,231,146),Color("555059"))
    draw_rect(Rect2(1039,164,202,107),Color("322e35"))
    draw_circle(Vector2(1140,219),49,Color("f9a43d"))
    draw_circle(Vector2(1140,218),42,Color("e9c070"))
    for k in range(7):
        var a:float=TAU*k/7.0
        draw_circle(Vector2(1140,218)+Vector2(cos(a),sin(a))*29,7,Color("d94b37"))
    word("STONE OVEN",Vector2(1141,283),15,Color("fff1cf"))

    if chef_walk_remaining > 0.0 and not chef_walk_frames.is_empty() and running:
        var walk_progress: float = 1.0 - chef_walk_remaining / CHEF_WALK_SECONDS
        var walk_frame: int = mini(7, int(walk_progress * 8.0))
        var kitchen_step: float = sin(walk_progress * PI) * 16.0
        draw_character_sprite(chef_walk_frames[walk_frame], Vector2(1141.0 + kitchen_step, 592.0), 105.0, false)
    elif chef_oven_in_remaining > 0.0 and not chef_oven_in_frames.is_empty() and running:
        var oven_progress: float = 1.0 - chef_oven_in_remaining / CHEF_OVEN_IN_SECONDS
        var oven_frame: int = mini(3, maxi(0, int(oven_progress * 4.0)))
        draw_character_sprite(chef_oven_in_frames[oven_frame], Vector2(1141, 405), 140.0)
    elif chef_oven_out_remaining > 0.0 and not chef_oven_out_frames.is_empty() and running:
        var out_progress: float = 1.0 - chef_oven_out_remaining / CHEF_OVEN_OUT_SECONDS
        var out_frame: int = mini(3, maxi(0, int(out_progress * 4.0)))
        # Pull from oven (back) -> rotate -> lower pizza toward the existing offscreen tray.
        var oven_to_tray: float = float(out_frame) / 3.0
        draw_character_sprite(chef_oven_out_frames[out_frame], Vector2(1141.0, lerpf(405.0, 592.0, oven_to_tray)), lerpf(140.0, 105.0, oven_to_tray))
    elif chef_active_table >= 0 and not chef_prepare_frames.is_empty() and running:
        var prepare_frame: int = int(tutorial_anim_time * 8.0) % 4
        draw_character_sprite(chef_prepare_frames[prepare_frame], Vector2(1141, 592), 105.0)
    else:
        draw_character_sprite(chef_poses[chef_pose_index()], Vector2(1141, 592), 105.0, chef_active_table >= 0)
    word("CHEF",Vector2(1144,608),13,Color("fff3d8"))
    # actress-like waiter with apron
    if has_upgrade("robot") and current_level >= 15:
        draw_circle(robot_pos + Vector2(0, 12), 17, Color("637187"))
        draw_circle(robot_pos, 21, Color("a4e2f1"))
        draw_rect(Rect2(robot_pos + Vector2(-13,-8), Vector2(26,16)), Color("293e58"))
        draw_circle(robot_pos + Vector2(-6,0), 3, Color("65e8a0"))
        draw_circle(robot_pos + Vector2(6,0), 3, Color("65e8a0"))
        if robot_busy: word("PIZZA ROBOT", robot_pos + Vector2(0,-28),12,Color("fdf5bf"))
    if waitress_is_walking and not waitress_walk_frames.is_empty():
        var walk_index: int = int(waitress_walk_time * 10.0) % waitress_walk_frames.size()
        var walk_tex: Texture2D = waitress_walk_frames[walk_index]
        if walk_tex != null:
            # Draw the same walk cycle in either direction without changing gameplay coordinates.
            if waitress_facing_left:
                draw_set_transform(waitress_pos + Vector2(0, 30), 0.0, Vector2(-1.0, 1.0))
                draw_character_sprite(walk_tex, Vector2.ZERO, 145.0, true)
                draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
            else:
                draw_character_sprite(walk_tex, waitress_pos + Vector2(0, 30), 145.0, true)
        else:
            draw_character_sprite(waitress_poses[waitress_pose_index()], waitress_pos + Vector2(0, 30), 145.0, true)
    else:
        draw_character_sprite(waitress_poses[waitress_pose_index()], waitress_pos + Vector2(0, 30), 145.0, false)
    
    if not held_tickets.is_empty(): word("TICKETS %d/2" % held_tickets.size(),waitress_pos+Vector2(0,-41),15,Color("fff3b5"))
    if not carried_pizzas.is_empty(): word("PIZZAS %d/%d" % [carried_pizzas.size(), 4 if has_upgrade("tray") else 2],waitress_pos+Vector2(0,-41),15,Color("fff3b5"))
    if not pending_cleaning.is_empty(): word("DISHES %d/%d" % [pending_cleaning.size(), dish_cart_capacity()],waitress_pos+Vector2(0,-59),15,Color("fff3b5"))
    for f in float_text:
        word(f["label"],f["pos"]+Vector2(0,-float(f["age"])*45),20,Color("fffbe8"))
    for p in particles:
        draw_circle(p["pos"],5,p["color"])
    
    # Bottom feedback/expansion panel intentionally hidden; gameplay logic stays active.

    draw_tutorial_cue()


# Alpha 12.56: development-only entrypoint; does not modify campaign saves.
func install_graphics_editor_shortcut() -> void:
    var editor_button := Button.new()
    editor_button.name = "GraphicsEditorLauncher"
    editor_button.text = "GRAPHICS EDITOR"
    editor_button.position = Vector2(1060, 670)
    editor_button.size = Vector2(195, 40)
    editor_button.tooltip_text = "Open graphics positioning editor; save progress first."
    editor_button.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/GraphicsEditor.tscn"))
    add_child(editor_button)
