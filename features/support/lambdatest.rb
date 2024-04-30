require 'yaml'
require 'selenium/webdriver'
require 'capybara/cucumber'

# monkey patch to avoid reset sessions
class Capybara::Selenium::Driver < Capybara::Driver::Base
  def reset!
    if @browser
      @browser.navigate.to('about:blank')
    end
  end
end

TASK_ID = (ENV['TASK_ID'] || 0).to_i
CONFIG_NAME = ENV['CONFIG_NAME'] || 'single'

CONFIG = YAML.load(File.read(File.join(File.dirname(__FILE__), "../../config/#{CONFIG_NAME}.config.yml")))
CONFIG['user'] = ENV['LT_USERNAME'] || CONFIG['user']
CONFIG['key'] = ENV['LT_ACCESS_KEY'] || CONFIG['key']


Capybara.register_driver :lambdatest do |app|


  options = Selenium::WebDriver::Chrome::Options.new
  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
      "browserName"=>"chrome", 
      "version"=>"latest",
      "build"=>"hyperexecute-capybara-lambdatest",
      "name"=>"capybara-lambdatest",
      "video"=>true,
      "network"=>true,
      "console"=>true,
      "visual"=>true 
  )


  Capybara::Selenium::Driver.new(app,
  browser: :remote,
  url: "https://#{CONFIG['user']}:#{CONFIG['key']}@#{CONFIG['server']}/wd/hub",
  options: capabilities,
)
end

Capybara.default_driver = :lambdatest
Capybara.run_server = false
