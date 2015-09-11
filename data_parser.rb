require "csv"

#putting contents of files into a strong
# filecontents = File.read("./planet_express_logs.csv")
# puts filecontents

# --------------------
# PART I:  MANIPULATE .csv data
# --------------------

# -
#Step 1 - convert CSV into useful ruby data structure ie. collection#

shipments = []

CSV.foreach("./planet_express_logs.csv", headers: true) do |row|
  shipments.push(row.to_hash)
end


puts '-'*15

#Step 2 - calculate total revenue


totalrevenue = 0

shipments.each do |shipment_hash|

  # shipment_hash = {
  #   "Destination"=>"xxx",
  #   "Shipment" => "xxx",
  #   "Crates" => "xxx",
  #   "Money" => "xxx"
  # }

  totalrevenue = totalrevenue + shipment_hash["Money"].to_i
end

puts totalrevenue

#Step 3 - How Much Bonus did the employees get.

bonus_fry = 0
bonus_amy = 0
bonus_bender = 0
bonus_leela = 0

trip_counter_fry = 0
trip_counter_amy = 0
trip_counter_bender = 0
trip_counter_leela = 0

#method is a way to perform a similar action on a certain input##
def calculate_bonus(rev, bonus_percentage)
  x = rev * bonus_percentage
  return x
end

bonus_pct = 0.10

shipments.each do |shipment_hash|

  # shipment_hash = {
  #   "Destination"=>"xxx",
  #   "Shipment" => "xxx",
  #   "Crates" => "xxx",
  #   "Money" => "xxx"
  # }

  if shipment_hash["Destination"] == "Earth"
    revenue_fry = shipment_hash["Money"].to_i
    bonus_fry = bonus_fry + calculate_bonus(revenue_fry, bonus_pct)

    trip_counter_fry = trip_counter_fry + 1

  elsif shipment_hash["Destination"] == "Mars"
    revenue_amy = shipment_hash["Money"].to_i
    bonus_amy = calculate_bonus(revenue_amy, bonus_pct)
    trip_counter_amy = trip_counter_amy + 1

  elsif shipment_hash["Destination"] == "Uranus"
    revenue_bender = shipment_hash["Money"].to_i
    bonus_bender = calculate_bonus(revenue_bender, bonus_pct)
    trip_counter_bender = trip_counter_bender + 1

  else
    revenue_leela = shipment_hash["Money"].to_i
    bonus_leela = calculate_bonus(revenue_leela, bonus_pct)
    trip_counter_leela = trip_counter_leela + 1

  end

end


# ...a better way....
# employee_stats = [
#  {"name"=>"Bender", "trips"=> 4, "bonus"=> 4000},
#  {"name"=>"Amy", "trips"=> 1, "bonus"=> 2000},
#  {"name"=>"Leela", "trips"=> 7, "bonus"=> 22000},
#  ...
# ]


#....hard mode ....
# I want to end up here...
#
# planet_stats = [
#  {"name" => "Earth". revenue=> "888"},
#  {"name" => "Mars". revenue=> "100"},
#  {"name" => "Moon". revenue=> "992"}
#  ...
# ]

planet_list = []

shipments.each do |shpmt|

  planet_found = planet_list.find{ |planet| planet["name"] == shpmt["Destination"]}

  if planet_found == nil

    new_planet = {
      "name" => shpmt["Destination"],
      "revenue" => shpmt["Money"].to_i
    }

    planet_list.push(new_planet)
  else
    planet_found["revenue"] = planet_found["revenue"] + shpmt["Money"].to_i
  end

end

puts planet_list

puts "---------------"

# ---------------------------------
# PART II:  OUTPUT .erb to .html with our data
# ---------------------------------
require "erb"

htmlstring = File.read("./layout.erb")

compiled_html = ERB.new(htmlstring).result(binding)

File.open("./index.html", "w+") do |f|
  f.write(compiled_html)
  f.close
end
