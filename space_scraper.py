import json
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.support.ui import Select
from selenium.webdriver.support.ui import WebDriverWait
from selenium.common.exceptions import NoSuchElementException
from selenium.common.exceptions import TimeoutException
import time

json_data = {}
old = new = ""

def visitCategories(filename):
	visitBlackList = ['00', '01']

	driver.find_element_by_xpath("//input[@id='LeftBar_contentplaceholder_control_chooseBldg_RadioButtonList_listby_1']").click()	
	time.sleep(2)

	options = Select(driver.find_element_by_xpath("//select[@id='LeftBar_contentplaceholder_control_chooseBldg_dropdownlist_bldglist']")).options
	for i in range(0, len(options)):
		options[i] = options[i].text

	for i in range(1, len(options)):
		currentCategory = options[i]
		if currentCategory not in visitBlackList:
			select = Select(driver.find_element_by_xpath("//select[@id='LeftBar_contentplaceholder_control_chooseBldg_dropdownlist_bldglist']"))
			select.select_by_index(i)
			categoryXPath = "//table[@id='LeftBar_contentplaceholder_control_chooseBldg_gridview_bldglist']/tbody/tr[2]/td[2]"
			WebDriverWait(driver, 5).until(EC.text_to_be_present_in_element((By.XPATH, categoryXPath), options[i]))
			visitBuildings()

	with open(filename, 'w') as outfile:
		json.dump(json_data, outfile)


def visitBuildings():
	bldgLinks = driver.find_elements_by_xpath("//td/a[@class='nav_bldgList']")
	for i in range(0, len(bldgLinks) - 2, 2):
		bldgLinks = driver.find_elements_by_xpath("//td/a[@class='nav_bldgList']")
		newBldgNumber = bldgLinks[i + 1].text	
		bldgLinks[i].click()
		bldgXPath = "//span[@id='Body_panel_restricted_body_label_bldgId']"
		WebDriverWait(driver, 5).until(EC.text_to_be_present_in_element((By.XPATH, bldgXPath), newBldgNumber))
		getPDFs()
		#json_data_new = getInfo()
		#json_data_new.update(getDetails())
		#bldgId = json_data_new['id']
		#json_data.update({bldgId : json_data_new})
	
		

def getInfo():
	json_data_new = {}
	json_data_new.update({'name'     : driver.find_element_by_xpath("//span[@id='Body_panel_restricted_body_label_bldgname']").text})
	json_data_new.update({'id'       : driver.find_element_by_xpath("//span[@id='Body_panel_restricted_body_label_bldgId']").text})
	json_data_new.update({'gsf'      : driver.find_element_by_xpath("//span[@id='Body_panel_restricted_body_label_gsf']").text})
	json_data_new.update({'ocf'      : driver.find_element_by_xpath("//span[@id='Body_panel_restricted_body_label_constyr']").text})
	json_data_new.update({'abbrev'   : driver.find_element_by_xpath("//span[@id='Body_panel_restricted_body_label_abbrev']").text})
	json_data_new.update({'address'  : driver.find_element_by_xpath("//span[@id='Body_panel_restricted_body_label_address']").text.title()})
	json_data_new.update({'city'     : driver.find_element_by_xpath("//span[@id='Body_panel_restricted_body_label_city']").text.title()})
	json_data_new.update({'state'    : driver.find_element_by_xpath("//span[@id='Body_panel_restricted_body_label_state']").text})
	json_data_new.update({'zipcode'  : driver.find_element_by_xpath("//span[@id='Body_panel_restricted_body_label_zip']").text})
	json_data_new.update({'status'   : driver.find_element_by_xpath("//span[@id='Body_panel_restricted_body_label_status']").text})
	json_data_new.update({'classif'  : driver.find_element_by_xpath("//span[@id='Body_panel_restricted_body_label_class']").text})
	json_data_new.update({'proptype' : driver.find_element_by_xpath("//span[@id='Body_panel_restricted_body_label_proptype']").text})
	json_data_new.update({'comments' : driver.find_element_by_xpath("//span[@id='Body_panel_restricted_body_label_comments']").text.capitalize()})
	try:
		json_data_new.update({'address2' : driver.find_element_by_xpath("//span[@id='Body_panel_restricted_body_label_address2").text.title()})
	except NoSuchElementException:
		json_data_new.update({'address2' : ""})

	return json_data_new

def getPDFs():
	try:
		pdfs = driver.find_elements_by_xpath("//div[@id='Body_panel_restricted_body_panel_floorplanbuttons']//a")
	except NoSuchElementException:
		pdfs = []
	# TODO FOLDERS BASED ON BLDGID
	for pdf in pdfs:
		pdf.click()
	
def getDetails():
	json_data_new = {}
	try:
		details = driver.find_elements_by_xpath("//table[@id='Body_panel_restricted_body_radiobuttonlist_infotype']/tbody//input")
		detailsText = driver.find_elements_by_xpath("//table[@id='Body_panel_restricted_body_radiobuttonlist_infotype']/tbody//label")
	except NoSuchElementException:
		details = detailsText = []
	for i in range(0, len(detailsText)):
		detailsText[i] = detailsText[i].text

	detailFuncList = [getRoomDetail, getBldgDetail, getDeptDetail, getUsageDetail, getSummaryDetail]	
	for i in range(0, len(details)):
		details = driver.find_elements_by_xpath("//table[@id='Body_panel_restricted_body_radiobuttonlist_infotype']/tbody//input")
		details[i].click()
		detailsData = detailFuncList[i]()
		json_data_new.update({detailsText[i] : detailsData})

	return json_data_new
			
def getRoomDetail():
	return getTableDetail('Body_panel_restricted_body_dropdownlist_floor', ['Body_panel_restricted_body_gridview_roomInfoTotals', 'Body_panel_restricted_body_gridview_roomInfo'], 'Room Info')

def getBldgDetail():
	return getTableDetail('', ['Body_panel_restricted_body_gridview_bldgTotals'], 'Building Info')

def getDeptDetail():
	return getTableDetail('Body_panel_restricted_body_dropdownlist_floor', ['Body_panel_restricted_body_gridview_deptTotals', 'Body_panel_restricted_body_gridview_deptInfo'], 'Department Info')

def getUsageDetail():
	return getTableDetail('Body_panel_restricted_body_dropdownlist_floor', ['Body_panel_restricted_body_gridview_usageTotals', 'Body_panel_restricted_body_gridview_usageRooms'], 'Usage Info')

def getSummaryDetail():
	return getTableDetail('Body_panel_restricted_body_dropdownlist_floor', ['Body_panel_restricted_body_gridview_stateguidelines', 'Body_panel_restricted_body_gridview_stateguidelinesAreas'], 'Summary')

def getTableDetail(selectID, tableIDs, initialCaption):
	selectXPath = "//select[@id='{selectID}']" . format(selectID = selectID)
	tableXPaths = []
	for i in range(0, len(tableIDs)):
		new_xpath = "//table[@id='{tableID}']" . format(tableID = tableIDs[i])
		tableXPaths.append(new_xpath)

	captionXPath = "{tableXPath}/caption" . format(tableXPath = tableXPaths[0])
	try:
		WebDriverWait(driver, 5).until(EC.text_to_be_present_in_element((By.XPATH, captionXPath), initialCaption))
	except TimeoutException:
		e = 1

	json_data_new = {}

	if selectID == '':
		for tableXPath in tableXPaths:
			json_data_new.update(getTable(tableXPath))

	try:
		options = Select(driver.find_element_by_xpath(selectXPath)).options
	except NoSuchElementException:
		options = []

	for i in range(0, len(options)):
		options[i] = options[i].text

	for i in range(0, len(options)):
		select = Select(driver.find_element_by_xpath(selectXPath))
		select.select_by_index(i)
		captionXPath = "{tableXPath}/caption" . format(tableXPath = tableXPaths[0])
		try:
			WebDriverWait(driver, 5).until(EC.text_to_be_present_in_element((By.XPATH, captionXPath), options[i]))
		except TimeoutException:
			e = 1
		json_data_new.update({options[i] : {}})
		for tableXPath in tableXPaths:
			try:
				json_data_new[options[i]].update(getTable(tableXPath))
			except NoSuchElementException:
				e = 1
	
	return json_data_new

def getTable(tableID, caption, label):
	json_data_new = {}
	#caption = driver.find_element_by_xpath("{tableID}/caption" . format(tableID = tableID))
	#headers = driver.find_elements_by_xpath("{tableID}/tbody/tr/th" . format(tableID = tableID))
	headers = ["Specific Id", "Type", "Description"]
	data = driver.find_elements_by_xpath("{tableID}/tbody/tr/td" . format(tableID = tableID))
	
	#json_data_new = {caption.text : []}
	json_data_new = {caption : []}
	headerLen = len(headers)
	for i in range(0, len(data), headerLen):
		new_json = {}
		for j in range(0, headerLen):
			#key = headers[j].text
			key = headers[j]
			value = data[i + j].text
			new_json[key] = value
		#json_data_new[caption.text].append(new_json)
		json_data_new[caption].append(new_json)

	return json_data_new
	


driver = webdriver.Chrome()
driver.get("https://space.facilities.vt.edu/Lock/bldgAndRoom.aspx")
input("Press Enter After you've logged in...")
#visitCategories(driver)
