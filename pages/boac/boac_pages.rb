require_relative '../../util/spec_helper'

module BOACPages

  include PageObject
  include Logging
  include Page

  ### PAGE LOADS ###

  div(:spinner, id: 'spinner-when-loading')

  # Waits for an expected page title
  # @param page_title [String]
  def wait_for_title(page_title)
    start = Time.now
    wait_until(Utils.medium_wait) { title == "#{page_title} | BOAC" }
    logger.debug "Page title updated in #{Time.now - start} seconds"
  end

  # Waits for the spinner to vanish following a page load and returns the number of seconds it took the spinner to vanish if greater than 1
  # @return [Float]
  def wait_for_spinner
    start = Time.now
    sleep 1
    if spinner?
      spinner_element.when_not_visible Utils.medium_wait rescue Selenium::WebDriver::Error::StaleElementReferenceError
      wait = Time.now - start
      logger.debug "Spinner lasted for #{wait} seconds"
      wait
    else
      logger.debug 'Spinner lasted less than 1 second'
    end
  end

  ### HEADER ###

  link(:home_link, text: 'Home')
  button(:header_dropdown, xpath: '//button[contains(@id,"header-dropdown-under-name")]')
  link(:admin_link, text: 'Admin')
  link(:log_out_link, text: 'Log Out')
  link(:feedback_link, text: 'Feedback/Help')
  div(:modal, class: 'modal-content')
  h1(:student_name_heading, id: 'student-name-header')

  # Clicks the 'Home' link in the header
  def click_home
    wait_for_load_and_click home_link_element
  end

  # Clicks the header name button to reveal additional links
  def click_header_dropdown
    sleep 2
    wait_for_update_and_click_js header_dropdown_element
  end

  # Clicks the 'Log out' link in the header
  def log_out
    logger.info 'Logging out'
    click_header_dropdown
    wait_for_update_and_click_js log_out_link_element
    wait_for_title 'Welcome'
  end

  # Clicks the 'Admin' link in the header
  def click_admin_link
    click_header_dropdown
    wait_for_update_and_click_js admin_link_element
    wait_for_title 'Admin'
  end

  ### SIDEBAR - CURATED GROUPS ###

  elements(:sidebar_curated_group_link, :link, xpath: '//a[contains(@id,"sidebar-curated-cohort")]')

  # Returns the names of all the curated groups in the sidebar
  # @return [Array<String>]
  def sidebar_groups
    sleep Utils.click_wait
    sidebar_curated_group_link_elements.map &:text
  end

  # Waits for a curated group's member count in the sidebar to match expectations
  # @param group [CuratedGroup]
  def wait_for_sidebar_group_member_count(group)
    logger.debug "Waiting for curated group member count of #{group.members.length}"
    wait_until(Utils.short_wait) do
      el = span_element(xpath: "//div[@class=\"sidebar-row-link\"][contains(.,\"#{group.name}\")]//span[@class=\"sr-only\"]")
      (el && el.text.delete(' students').chomp) == group.members.length.to_s
    end
  end

  # Waits for a curated group to appear in the sidebar with the right member count and obtains the cohort's ID
  # @param group [CuratedGroup]
  def wait_for_sidebar_group(group)
    wait_until(Utils.short_wait) { sidebar_groups.include? group.name }
    wait_for_sidebar_group_member_count group
    BOACUtils.set_curated_group_id group
  end

  ### SIDEBAR - FILTERED COHORTS ###

  link(:create_filtered_cohort_link, id: 'sidebar-filtered-cohort-create')
  link(:view_everyone_cohorts_link, id: 'sidebar-filtered-cohorts-all')
  link(:team_list_link, id: 'sidebar-teams-link')
  link(:intensive_cohort_link, text: 'Intensive Students')
  link(:inactive_cohort_link, text: 'Inactive Students')
  elements(:filtered_cohort_link, :link, xpath: '//div[@class="sidebar-row-link"]//a[contains(@id,"sidebar-filtered-cohort")][contains(@href,"/cohort/")]')
  div(:dupe_filtered_name_msg, xpath: '//div[text()="You have an existing cohort with this name. Please choose a different name."]')

  # Clicks the button to create a new custom cohort
  def click_sidebar_create_filtered
    logger.debug 'Clicking sidebar button to create a filtered cohort'
    wait_for_load_and_click create_filtered_cohort_link_element
    wait_for_title 'Create Cohort'
    sleep 3
  end

  # Clicks the link for the Teams List page
  def click_teams_list
    wait_for_load_and_click team_list_link_element
    wait_for_title 'Teams'
  end

  # Clicks the link for the Intensive cohort
  def click_intensive_cohort
    wait_for_load_and_click intensive_cohort_link_element
    wait_for_title 'Intensive'
  end

  # Clicks the link for the Inactive cohort
  def click_inactive_cohort
    wait_for_load_and_click inactive_cohort_link_element
    wait_for_title 'Inactive'
  end

  # Clicks the button to view all custom cohorts
  def click_view_everyone_cohorts
    sleep 2
    wait_for_load_and_click view_everyone_cohorts_link_element
    wait_for_title 'Filtered Cohorts All'
  end

  # Clicks the sidebar link to a filtered cohort
  # @param cohort [FilteredCohort]
  def click_sidebar_filtered_link(cohort)
    link = filtered_cohort_link_elements.find(&:text) == cohort.name
    wait_for_update_and_click link
  end

  ### SIDEBAR - USER SEARCH ###

  text_area(:search_input, id: 'search-students-input')

  # Searches for a string using the sidebar search input
  # @param string [String]
  def search(string)
    logger.info "Searching for '#{string}'"
    sleep 1
    search_input_element.when_visible Utils.short_wait
    self.search_input = string
    search_input_element.send_keys :enter
    wait_for_spinner
  end

  # Returns the XPath to a boxplot nested under another element
  # @return [String]
  def boxplot_xpath
    "//*[name()='svg']/*[name()='g'][@class='highcharts-series-group']"
  end

  # Returns the XPath to a boxplot's tooltip trigger nested under another element
  # @return [String]
  def boxplot_trigger_xpath
    "#{boxplot_xpath}/*[name()='g']/*[name()='g']/*[name()='path'][3]"
  end

end
