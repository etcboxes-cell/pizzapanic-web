# Wrong pizza recovery — Alpha 12.10.4

For ingredient pizzas (Days 6+), choosing incorrect toppings is allowed at cooking.
On delivery, the customer rejects incorrect toppings, loses 15 patience, and the ticket returns to the chef queue.
If an **already submitted** order at another table matches the rejected pizza exactly,
it is redirected to that table's pickup slot automatically, bypassing recooking.
Otherwise the returned pizza is discarded.
No double payments or double servings for a returned pizza.
Test manually in Godot, especially robot delivery after Day 16.
