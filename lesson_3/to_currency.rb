def to_currency(string)
  return "Invalid Input" unless /^\d*\.?\d+$/.match(string)

  rounded_number = string.to_f.round(2).to_s
  number_array = rounded_number.split(".")

  number_array[1] << "0" if number_array[1].length == 1

  main_number = number_array[0].split("")
  formatted = []
  n = 0
  if main_number.length > 3
    main_number.reverse.each do |num|
      formatted << num
      n += 1
      formatted << "," if n % 3 == 0 unless n == main_number.length
    end
    number_array[0] = formatted.reverse.join("")
    number_array.join(".").prepend"$"
  else
  rounded_number.prepend"$"
  end
end
