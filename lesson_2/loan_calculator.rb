def prompt(style, message)
  puts "*** #{message} ***" if style == "title"
  puts "=> #{message}" if style == "input"
  puts "!!! #{message} !!!" if style == "error"
end

def valid_number?(number)
  /^\d*\.?\d+$/.match(number)
end

prompt("title", "Welcome To The Loan Calculator!")
loop do 
  prompt("input", "Please enter the loan amount\n(Must be a positive number excluding the currency symbol and any commas e.g. 250750 instead of $250,750):")
  loan_amount = ""
  loop do
    loan_amount = gets.chomp
    break if valid_number?(loan_amount)
    prompt("error", "Please enter a valid loan amount\n(Must be a positive number excluding the currency symbol and any commas e.g. 250750 instead of $250,750):")
  end
  loan_amount = loan_amount.to_f

  prompt("input", "Please enter the APR\n(Must be a positive number excluding the percentage symbol e.g. 7.5 for 7.5%):")
  apr = ""
  loop do
    apr = gets.chomp
    break if valid_number?(apr)
    prompt("error", "Please enter a valid APR\n(Must be a positive number excluding the percentage symbol e.g. 7.5 for 7.5%):")
  end
  apr = apr.to_f
  monthly_int = apr / 100 / 12

  prompt("input", "Please enter the Loan Term in Years\n(e.g. 5 for 5years or 3.5 for 3 and a half years):")
  term = ""
  loop do
    term = gets.chomp
    break if valid_number?(term)
    prompt("error", "Please enter a valid Loan term in Years:")
  end
  term = term.to_f
  term_months = term * 12.to_i

  payment = loan_amount *
            (monthly_int * (1 + monthly_int)**term_months) /
            ((1 + monthly_int)**term_months - 1)

  prompt("title", "Your monthly payment is: €#{payment.round(2)}\n")

  prompt("input", "Would you like to perform another calculation (y for yes):")
  again = gets.chomp
  break unless again == "y"
end
