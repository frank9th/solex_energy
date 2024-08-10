


#calculate for totalPower
def calculate_Total_Power(qty:int= 0, unitPower:int= 0):
		"""calculate the total power based on the device unit power in watts and the quantity the user have.
			Args:
				qty: device quanty e.g 6 Fans, 3 Tv set, 1 pressing iorn, etc.
				unitPower: The device unit power in watts e.g 15watts or 15, Fan is 75w etc. 
		"""
		return qty * unitPower

#calculate dailyEnergy
def dailyEnergy(dailyUsage:int = 0, totalPower:int = 0):
	"""calculate the daily usage of the device in hour(s)
    Args:
        dailyUsage: The number of ours the system should be on e.g 6 hours or 6, 7hrs , 10hrs, etc.
        totalPower: This is total power of the device which is power * quantity
    """
	return totalPower * dailyUsage

#//SOLVE FOR SYSTEM VOLTAGE . FORMULAR = DE/1000
def calculate_system_voltage(dailyEnergy:int = 0):
	"""calculate for the system voltage required for the clients system
		#FORMULAR = DAILY ENERGY (ED) / 1000
		Args:
			dailyEnergy: This is the daily energy required by the system 
	"""
	volt = 12
	result = dailyEnergy / 1000
	newR = result
	if newR <= 2:
		volt = 12
	elif newR > 1 and  newR <= 4 :
		volt = 24
	elif newR > 3 and newR <= 14:
		volt = 48
	return volt;

#B3 CAPACITY
def calculate_Battery_capacity(dailyEnergy:int = 0, system_volt:int = 12):
	"""calculate for the system battery capacity, using the FORMULAR to determine the battery capacity for the system, the result in Ah
	    Args:
	        dialyEnergy: This is the formular to calculate for daily energy which is
	        total power * daily usage e.g 3700watts * 5hrs
	        DOA: Days of Anatomy, assuming its 1
	        DOD: Depth of discharge, assuming we are allowing the battery distacharge to 80% 
	        system_volt: The system voltage calculated or selected for the system  e.g 24v, 48v, 60v, 90v etc.
	        B3E: Battery Efficiency, assuming a battery efficency of 85 - 90% 

	"""
	#FORMULAR 
	#b3c = Edaily x DOA / DOD X SV X B3E (EFFICIENCY)
	x = dailyEnergy * 1 
	y = 0.8 * system_volt * 0.85
	result = x / y

	return result

def calculate_batery_Size(system_volt:int = 0, selected_battery_volt:int = 12, selected_battery_ah:int = 200, battery_capacity:int = 500):
	"""calculate for the system battery size or numbers 
		#BATTERY SIZING - NUMBERS OF Batteries TO USE OR BUY
		#FORMULAR = SYSTEM V/SELECTED Battery Voltage X SYSTEM BATTERY CAPACITY / SELECTED BATTERY CAPACITY
	    Args:
	    	selected_battery: This is the selected battery a user decideds to use or the model recomends. e.g 12v, 200ah
	    	The selected battery contains the battery voltage and capacity in ah or kwh e.g 12v, 310ah, 24v, 15kw, 12v, 100ah etc.
	    	system_volt: This is the system volts, giving, recommended or already calculated for e.g 24v 
	    	seleted_battery_volt: This is the selected, or recommended battery voltage e.g 12v 
	    	selected_battery_ah: This is selected battery power e.g 200ah, 300ah, 100ah. etc. 
	    	battery_capacity: This is the calculation for the system battery capacity e.g 1200ah battery capacity 
	"""
	size = 0
	x = system_volt / selected_battery_volt
	y = battery_capacity / selected_battery_ah
	result = x * y
	size = result
	return size

# NUMBER OF PARAlE CONNECTION
#FORMULAR  = B3C/SB3C
def calculatePConnet(b3c:int = 0, sb3:int = 0):
	""" calculate for the paralle connection for the selected or recommended battery to give the required voltage (v) 
		# NUMBER OF PARRALE CONNECTION
		#FORMULAR  = B3C/SB3C
		Args:
			b3c: This is the system battery capacity e.g  2000ah 
			sb3: This is the giving or recommended battery capacity eg. 200ah 
	"""
	pConnet = b3c / sb3
	return pConnet
  
#NUMBER OF SERIES CONNECTION
#FORMULAR  = SV/SB3V
def calculateSconnet(system_volt:int = 0, selected_volt:int=0):
	""" calculate serries connection for the selected or recommended battery to give the required power  (ah or kw)
		# NUMBER OF SERRIES CONNECTION
		#FORMULAR  = SYSTEM_VOLT / SELECTED_VOLT
		Args:
				system_volt: This is the system voltage e.g 12v, 24v, 48v, 60v, 90v, etc. 
				selected_volt: This is the giving or recommended battery volt eg. 2v, 6v, 12v, 24v, 48v, etc. 
	"""
	result = system_volt / selected_volt
	return result

def calculatePvModelPW(phs:int= 4, dailyEnergy:int = 0):
	""" CALCULATE FOR THE TOTAL PV MODEL POWER (WATTS) assuming the PPR is 0.75
		#NUMBER OF PV MODULES
		#FORMULAR = ED/ PSH X PPR
		#PSH - PEAK SUN HOUR
		#PPR - PANEL PERFORMANCE RATION (0.65)
		#SELECT REGION TO GET THE PSH
 		 // THIS CALCULATES THE TOTAL PANEL POWER NEEDED
 		 Args:
 		 		phs: This is the peak sun our depending on the users region e.g psh for Nigeria are; 
 		 		- Mangrove swamp [Yenegoa, Lagos, Ph, Delta ] phs = 4.0
 		 		- High Rainforest [Ibadan, Akwa , Enugu] phs - 4.5
 		 		- Guinea Savannah [Abuja, Kaduna ] phs - 5.0
 		 		- Sudan Savannah [ Kanji, Kano] - phs - 5.5
 		 		dailyEnergy: This is the system daily energy (EDaily) required e.g 4000w 

	"""
	x = phs * 0.75
	return  dailyEnergy / x


def calculatePvNumbers(panel_watts:int=300, totalPvPower:int = 1200):
    """ calculate for the numbers of panels needed with a provided or recommended panel capacity 
    		e.g 300w 24v pannel, 12v 180w panel, 24v 450w panel etc. 
    		 #FORMULAR = REQUIRED WP/ SELECTED PANEL WP

    	Args:
    			totalPower: the total watts power of the model eg 6800wp which is calculated by dividing the Edaly (ED) / PSH x PPR
				panel_watts: this is the recommended or provided panel watts eg. 300w, 450w, 280w etc.  

    """
    return totalPvPower / panel_watts


def calculate_pv_parale_connection(pv_mudle_power:int = 1400, panel_watts:int=300):
	""" calculate for the paralle connection for the selected or recommended panel to give the required parale connection
		# NUMBER OF PARRALE CONNECTION
		#FORMULAR  = PV_MODULE_POWER(Wh)/PANEL_WATTS (W)
		Args:
				pv_mudle_power: This is the system pv power needed e.g 1400wp
				panel_watts: This is the giving or recommended panel watts eg. 300w 
	"""
	return pv_mudle_power / panel_watts


#NUMBER OF SERIES CONNECTION
#FORMULAR  = SV/PANEL VOLTAGE 
def calculatePvSconnet(system_volt:int = 0, selected_volt:int= 0):
	""" calculate serries connection for the selected or recommended battery to give the required power  (ah or kw)
		# NUMBER OF SERRIES CONNECTION
		#FORMULAR  = SYSTEM_VOLT / SELECTED_VOLT
		Args:
			system_volt: This is the system voltage e.g 12v, 24v, 48v, 60v, 90v, etc. 
			selected_volt: This is the giving or recommended panel volt eg.  12v, 24v.
	"""
	result = system_volt / selected_volt
	return result

	
  

 #CHARGE CONTROLLER SIZING
def calculateChargeControl(panel_watts:int = 300, totalPvParalleConnect:int = 3):
	""" calculate for charge controller assuming the power is multiplied and the voltage is constant using a giving or standard vmp
		#FORMULAR = VMP / PARALLE CONNECTIONS * 1.25
		Args: 
			panel_watts: This is the watts of the giving or recommended panel eg. 300w, 450w, 550w etc. 
			totalPVParralleConnent: This is the number of paralle connections of the panels 
			vmp: use a standard vmp if not giving. 
	"""
	vmp = 36 # calculate for the vmp or use a provided / standard vmp. for a 24v panel, the vmp ranges from 30v to 36v. and for a 12v is between 17, 18 or more. 

	imp = panel_watts / vmp # get the imp of each pannel 
	return imp * totalPvParalleConnect * 1.25
  

  #INVERTER SIZING
def calculateInverter(totalPower:int = 4500):
	""" Calculate for inverter required for the system with a tolerance of 1.25 and inverter efficiency of 85%. inverter result in VA, Watt or KVA
		#FORMULAR = TOTAL POWER / INVERTER EFFICIENCY X 1.25
		Args:
			totalPower: This is the total power or load (w) the inverter should carry.
	"""
	x = totalPower / 0.85 # totalPower (w) / Inverter efficency assuming the efficiency to be 80%, inverters can have up to 90- 95% efficiency 
	return  x * 1.25
	

