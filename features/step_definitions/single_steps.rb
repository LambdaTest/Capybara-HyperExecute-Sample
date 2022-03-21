When /^I click on first item$/ do
  page.find(:xpath,"//*[@name='li1']").click
end

When /^I click on second item$/ do
  page.find(:xpath,"//*[@name='li2']").click
end

When /^I add new item "([^\"]*)"$/ do |keys|
  page.find(:xpath,"//*[@id='sampletodotext']").click
  fill_in('sampletodotext', :with => keys)
  page.find(:xpath,"//*[@id='addbutton']").click
end

Then /^I should see new item in list "([^\"]*)"$/ do |keys|
  expect(page).to have_content(keys)
  page.execute_script('lambda-status=Passed');
end

Then /^I should open Playground$/ do
  visit "https://www.lambdatest.com/selenium-playground/"
  page.find(:xpath, "//a[contains(text(),'Simple Form Demo')]").click
  page.find(:xpath, "//a[contains(text(),'Checkbox Demo')]").click
  page.find(:xpath, "//a[contains(text(),'Radio Buttons Demo')]").click
  page.find(:xpath, "//a[contains(text(),'Select Dropdown List')]").click
  page.find(:xpath, "//a[contains(text(),'Input Form Submit')]").click
  page.find(:xpath, "//a[contains(text(),'Ajax Form Submit')]").click
  page.find(:xpath, "//a[contains(text(),'JQuery Select dropdown')]").click

  page.find(:xpath, "//p[contains(text(),'Alert & Modals')]").click
  page.find(:xpath, "//a[contains(text(),'Bootstrap Alerts')]").click
  page.find(:xpath, "//a[contains(text(),'Bootstrap Modals')]").click
  page.find(:xpath, "//a[contains(text(),'Window Popup Modal')]").click
  page.find(:xpath, "//a[contains(text(),'Progress Bar Modal')]").click
  page.find(:xpath, "//a[contains(text(),'Javascript Alerts')]").click
  page.find(:xpath, "//a[contains(text(),'File Download')]").click

  page.find(:xpath, "//p[contains(text(),'Data Pickers')]").click
  page.find(:xpath, "//a[contains(text(),'Bootstrap Date Picker')]").click
  page.find(:xpath, "//a[contains(text(),'JQuery Date Picker')]").click

  page.find(:xpath, "//p[contains(text(),'Progress Bar & Sliders')]").click
  page.find(:xpath, "//a[contains(text(),'JQuery Download Progress bars')]").click
  page.find(:xpath, "//a[contains(text(),'Bootstrap Progress bar')]").click
  page.find(:xpath, "//a[contains(text(),'Drag & Drop Sliders')]").click

  page.find(:xpath, "//p[contains(text(),'List Box')]").click
  page.find(:xpath, "//a[contains(text(),'Bootstrap List Box')]").click
  page.find(:xpath, "//a[contains(text(),'JQuery List Box')]").click
  page.find(:xpath, "//a[contains(text(),'Data List Filter')]").click

  page.find(:xpath, "//p[contains(text(),'Others')]").click
  page.find(:xpath, "//a[contains(text(),'Drag and Drop')]").click
  page.find(:xpath, "//a[contains(text(),'Dynamic Data Loading')]").click
  page.find(:xpath, "//a[contains(text(),'Hover Demo')]").click
end
