resource "random_id" "random" {
  byte_length = 8
}

output "shop_name" {
  value = "Duck Donuts"
}

output "flavors" {
  value = [
    "Maple Bacon",
    "Old-Fashioned",
    "Glazed w/ Rainbow Sprinkles",
    "Blueberry Glaze",
  ]
}

output "orders" {
  value = {
    Dallas = "Maple Bacon"
    Gabi   = "Glazed w/ Rainbow Sprinkles"
    Sage   = "Blueberry"
    Paris  = "null"
  }
}

