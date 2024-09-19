extends Node

var NumberSuffixes = ["", "K", "M", "B", "T", "q", "Q", "s", "S", "O", "N", "D"]


#Conversion Functions
func string_to_array(inputString : String):
	
	#Makes a copy of the inputString.
	var numString = String(inputString)
	
	#Makes a blank array for the output.
	var numArray = []
	
	#While the input  string still contains numbers:
	while numString != "":
		
		#If the next "digit" is a decimal place, add that in as a string.
		if numString.begins_with("."):
			numArray.push_back(".")
			numString = numString.substr(1, numString.length())
		
		#Remove the first digit of the string and add it as an
		#integer to the beginning of the array.
		numArray.push_back(int(numString.substr(0, 1)))
		numString = numString.substr(1, numString.length())

	return numArray

func array_to_string(inputArray : Array):
	
	#Makes a copy of the input array.
	var numArray = inputArray.duplicate()
	
	var numString = ""
	
	#While the input array still contains numbers:
	while numArray != []:
		
		#Add the first digit of the array to the end of the string.
		numString = numString + str(numArray.pop_front())
	
	return numString

func array_to_display(inputArray : Array):
	
	#Makes a copy of the input array.
	var numArray = inputArray.duplicate()
	
	var numDisplay = ""
	
	if numArray.size() <= 3 and !numArray.has("."):
		for i in numArray.size():
			numDisplay = numDisplay + str(numArray.pop_front())
	
	#If there is a decimal point, remove any digits after that, as well as the decimal itself.
	if numArray.has("."):
		
		#If there are less than 2 digits before the decimal point:
		if numArray.find(".") < 2:
			#Remove all decimal places except the first one.
			numArray.resize(numArray.find(".") + 2)
			for i in numArray.size():
				numDisplay = numDisplay + str(numArray.pop_front())
			return numDisplay
		else:
			#Remove all decimal places, and the decimal.
			numArray.resize(numArray.find("."))
	
	var index = 0
	var size = numArray.size()
	
	while size > 3:
		size -= 3
		index += 1
	
	#If the remainder is equal to 1:
	if size == 1:
		numArray.resize(size + 1)
		for i in numArray.size():
			numDisplay = numDisplay + str(numArray.pop_front())
			
		numDisplay = numDisplay.substr(0, numDisplay.length() - 1) + "." + numDisplay.substr(numDisplay.length() -1, -1)
		
	else:
		numArray.resize(size)
		for i in numArray.size():
			numDisplay = numDisplay + str(numArray.pop_front())
	
	numDisplay = numDisplay + NumberSuffixes[index]
	
	return numDisplay


#Helpful Functions:
func prepare_decimal_arrays(inputArray1 : Array, inputArray2 : Array, multiplication : bool):
	
	var numArray1 = inputArray1.duplicate()
	var numArray2 = inputArray2.duplicate()
	
	var decimal_places = 0
	
	#If one of the arrays does not have a decimal point, add one at the end.
	if !numArray1.has("."):
		numArray1.push_back(".")
	if !numArray2.has("."):
		numArray2.push_back(".")
		
	#Finds out how many digits are after each decimal point.
	var numArray1_decimals = numArray1.size() - (numArray1.find(".") + 1)
	var numArray2_decimals = numArray2.size() - (numArray2.find(".") + 1)
	
	#If either one has less decimal places than the other, add zeros to match.
	#Also sets the decimal_places variable to whichever is higher.
	if numArray1_decimals < numArray2_decimals:
		for i in range(0, numArray2_decimals - numArray1_decimals):
			decimal_places = numArray2_decimals
			numArray1.push_back(0)
	elif numArray2_decimals < numArray1_decimals:
		for i in range(0, numArray1_decimals - numArray2_decimals):
			decimal_places = numArray1_decimals
			numArray2.push_back(0)
	else:
		decimal_places = numArray1_decimals
	
	if multiplication == true:
		decimal_places *= 2
		
	#Removes the decimal places so they don't interfere with the addition.
	numArray1.erase(".")
	numArray2.erase(".")
	
	return[numArray1, numArray2, decimal_places]

func array_is_greater_than(inputArray1 : Array, inputArray2 : Array):
	
	var numArray1 = inputArray1.duplicate()
	var numArray2 = inputArray2.duplicate()
	
	var decimal_places
	var output : bool
	
	#If either array has a decimal point.
	if numArray1.has(".") or numArray2.has("."):
		
		#If one of the arrays does not have a decimal point, add one at the end.
		if !numArray1.has("."):
			numArray1.push_back(".")
		if !numArray2.has("."):
			numArray2.push_back(".")
		
		#Finds out how many digits are after each decimal point.
		var numArray1_decimals = numArray1.size() - (numArray1.find(".") + 1)
		var numArray2_decimals = numArray2.size() - (numArray2.find(".") + 1)
		
		#Whichever array has more decimal places, remove the decimal and set decimal_places to that many places.
		if numArray1_decimals > numArray2_decimals:
			
			numArray1.erase(".")
			decimal_places = numArray1_decimals
			
			while numArray2_decimals < decimal_places:
				numArray2.push_back(0)
				numArray2_decimals += 1
			
			numArray2.erase(".")
			
		elif numArray2_decimals > numArray1_decimals:
			
			numArray2.erase(".")
			decimal_places = numArray2_decimals
			
			while numArray1_decimals < decimal_places:
				numArray1.push_back(0)
				numArray1_decimals += 1
			
			numArray1.erase(".")
	
	
	#If there are more digits in array 1 than 2, set output to true.
	if numArray1.size() > numArray2.size():
		output = true 
	#If the number of digits are the same:
	elif numArray1.size() == numArray2.size():
		
		#For each digit of the arrays:
		for i in range(0, numArray1.size()):
			
			#If the digit in the first array is greater, outptu true.
			if numArray1[i] > numArray2[i]:
				output = true
				break
				
			#If the two digits are equal, go to the next one.
			elif numArray1[i] == numArray2[i]:
				pass
				
			#Otherwise, the digit of the first array must be smaller, so output false.
			else:
				output = false
				break
	
	return output

func truncate_array(inputArray : Array, output_decimal_places : int):
	
	var numArray1 = inputArray.duplicate()
	
	if numArray1.has("."):
		
		numArray1.resize(numArray1.find(".") + output_decimal_places + 1)
		
		if output_decimal_places == 0:
			numArray1.erase(".")
		
	else:
		return numArray1
	
	return numArray1


#Arithmetic Functions
func add_arrays(inputArray1 : Array, inputArray2 : Array):
	
	#Duplicates the input arrays.
	var numArray1 = inputArray1.duplicate()
	var numArray2 = inputArray2.duplicate()
	
	var decimal_places = 0
	var numArray3 = []
	
	#If either one has a decimal point:
	if numArray1.has(".") or numArray2.has("."):
		var output = prepare_decimal_arrays(numArray1, numArray2, false)
		numArray1 = output[0]
		numArray2 = output[1]
		decimal_places = output[2]

	
	#Sets blank variables for the sum of each digit, as well as a carry digit.
	var carry = 0
	var temp = 0
	
	#While either input array still contains digits:
	while numArray1.size() > 0 or numArray2.size() > 0:
		
		if numArray1 == []:
			numArray1 = [0]
		if numArray2 == []:
			numArray2 = [0]
		
		#Sets the temp variable equal to the sum of the last digit of each array,
		#plus the carry of the previous sum.
		temp = numArray1.pop_back() + numArray2.pop_back() + carry
		
		#If the sum is over 10, subtract 10 and set the carry to 1.
		if temp >= 10:
			temp -= 10
			carry = 1
		
		#Otherwise, reset the carry variable.
		else:
			carry = 0
		
		#Add the resulting temp variable the the beggining of the output array.
		numArray3.push_front(temp)
	
	#After all of that, if there still is a carry, just add it as a new segemnt of the output array.
	if carry > 0:
		numArray3.push_front(carry)
	
	#If the decimal needs to be added back in:
	if decimal_places != 0:
		numArray3.insert(numArray3.size() - decimal_places, ".")
	
	return numArray3

func subtract_arrays(inputArray1 : Array, inputArray2 : Array):
	
	#Duplicates the input arrays.
	var numArray1 = inputArray1.duplicate()
	var numArray2 = inputArray2.duplicate()
	
	var decimal_places = 0
	var numArray3 = []
	
	#If either one has a decimal point:
	if numArray1.has(".") or numArray2.has("."):
		var output = prepare_decimal_arrays(numArray1, numArray2, false)
		numArray1 = output[0]
		numArray2 = output[1]
		decimal_places = output[2]

	
	#Sets blank variables for the sum of each 3 digit segment, as well as a carry digit.
	var carry = 0
	var temp = 0
	
	#While either input array still contains digits:
	while numArray1.size() > 0 or numArray2.size() > 0:
		
		#If either array runs out of digits, add a zero.
		if numArray1.size() == 0:
			numArray1.push_back(0)
		if numArray2.size() == 0:
			numArray2.push_back(0)
		
		#If subtracting the two digits and the carry would give a negative number:
		if (numArray1.back() - numArray2.back() - carry) < 0:
			
			#Set the temp variable to equal the first digit plus 10 (6 --> 16)
			temp = numArray1.pop_back() + 10
			#Subtract the carry taken from the previous subtraction (if any).
			temp -= carry
			#Set the carry to 1.
			carry = 1
			
			#Set the first digit of the output array to equal temp minus the last digit of array 2.
			numArray3.push_front(temp - numArray2.pop_back())
		
		#If subtracting the two and carry won't give a negative number:
		else:
			
			#Set the first digit of the output array to equal to the first digit of array 1,
			#minus the first digit of array 2, and the carry.
			numArray3.push_front(numArray1.pop_back() - carry - numArray2.pop_back())
			
			#Reset the carry back to zero.
			carry = 0
	
	#If the decimal needs to be added back in:
	if decimal_places != 0:
		numArray3.insert(numArray3.size() - decimal_places, ".")
	
	#Removes trailing zeros on the number side.
	while numArray3.front() == 0 and (numArray3.size() > 1 and numArray3[1] is int):
		numArray3.pop_front()
	
	return numArray3

func multiply_array_by_single_digit(inputArray : Array, num : int):
	
	var numArray1 = inputArray.duplicate()
	var numArray2 = [num]
	
	
	var decimal_places = 0
	var numArray3 = []
	
	#If the input array has a decimal point:
	if numArray1.has("."):
		var output = prepare_decimal_arrays(numArray1, numArray2, false)
		numArray1 = output[0]
		numArray2 = output[1]
		decimal_places = output[2]
	
	var temp = 0
	var carry = 0
	
	while numArray1 != []:
		
		temp = (numArray1.pop_back() * num) + carry
		carry = 0
		while temp >= 10:
			temp -= 10
			carry += 1
		
		numArray3.push_front(temp)
	
	if carry != 0:
		numArray3.push_front(carry)
	
	#If the decimal needs to be added back in:
	if decimal_places != 0:
		numArray3.insert(numArray3.size() - decimal_places, ".")
	
	return numArray3

func multiply_arrays(inputArray1 : Array, inputArray2 : Array):
	
	#Duplicates the input arrays.
	var numArray1 = inputArray1.duplicate()
	var numArray2 = inputArray2.duplicate()
	
	var decimal_places = 0
	var numArray3 = []
	
	#If either one has a decimal point:
	if numArray1.has(".") or numArray2.has("."):
		var output = prepare_decimal_arrays(numArray1, numArray2, true)
		numArray1 = output[0]
		numArray2 = output[1]
		decimal_places = output[2]
	
	var temp = []
	
	for i in range(0, numArray1.size()):
		
		var numArray2_copy = numArray2.duplicate()
		
		for x in range(1, i):
			numArray2_copy.push_front(0)
		for y in range(i + 1, numArray1.size()):
			numArray2_copy.push_back(0)
		
		
		temp = multiply_array_by_single_digit(numArray2_copy, numArray1[i])
		
		numArray3 = add_arrays(numArray3, temp)
	
	#If the decimal needs to be added back in:
	if decimal_places != 0:
		numArray3.insert(numArray3.size() - decimal_places, ".")
		
		#Removes trailing zeros on the decimal side.
		while numArray3.back() is int and numArray3.back() == 0:
			numArray3.pop_back()
	
	#Removes trailing zeros on the number side.
	while numArray3.front() == 0 and (numArray3.size() > 1 and numArray3[1] is int):
		numArray3.pop_front()
	
	return numArray3

func divide_arrays(inputArray1 : Array, inputArray2 : Array, output_decimal_places : int):
	
	#Duplicates the input arrays.
	var numerator = inputArray1.duplicate()
	var denominator = inputArray2.duplicate()

	var decimal_places = 0
	var quotient = []
	
	#If either one has a decimal point:
	if numerator.has(".") or denominator.has("."):
		var output = prepare_decimal_arrays(numerator, denominator, true)
		numerator = output[0]
		denominator = output[1]
		decimal_places = output[2]
	
	var remainder = numerator.duplicate()
	
	#Gets the inital quotient, plus a remainder.
	while array_is_greater_than(remainder, denominator) == true:
		remainder = subtract_arrays(remainder, denominator)
		quotient = add_arrays(quotient, [1])

	#If the demoniator isn't larger or smaller than the numerator, they must be equal.
	if array_is_greater_than(denominator, remainder) == false:
		
		#Subtract one more time.
		remainder = subtract_arrays(remainder, denominator)
		quotient = add_arrays(quotient, [1])
	
	if remainder == [0]:
		return quotient
	
	#Repeat for as many decimal places as desired.
	for i in range (0, output_decimal_places):
		
		remainder.push_back(0)
		var remainder_quotient = 0
		
		while array_is_greater_than(remainder, denominator) == true:
			remainder = subtract_arrays(remainder, denominator)
			remainder_quotient += 1
			
	
		#If the demoniator isn't larger or smaller than the numerator, they must be equal.
		if array_is_greater_than(denominator, remainder) == false:
		
			#Subtract one more time.
			remainder = subtract_arrays(remainder, denominator)
			remainder_quotient += 1
		
		quotient.push_back(remainder_quotient)
	
	
	
	#Adds the decimal point in.
	quotient.insert(quotient.size() - output_decimal_places, ".")
	
	return quotient
