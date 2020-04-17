require 'rspec'
require 'rspec/core/rake_task'
require 'logger'
require "base64"
require 'csv'
require 'json'
require 'nokogiri'
require 'selenium-webdriver'
require 'fileutils'
require 'pg'
require 'redshift/client'
require 'time'
require 'yaml'

require_relative '../logging'
require_relative '../models/user'
require_relative '../models/test_config'
require_relative '../models/boac/boac_user'
require_relative '../models/boac/timeline_record'
require_relative '../models/boac/advisor_role'
require_relative '../models/boac/dept_membership'
require_relative '../models/boac/alert'
require_relative '../models/boac/appointment'
require_relative '../models/boac/appointment_status'
require_relative '../models/boac/attachment'
require_relative '../models/boac/cohort'
require_relative '../models/boac/cohort_admit_filter'
require_relative '../models/boac/cohort_filter'
require_relative '../models/boac/curated_group'
require_relative '../models/boac/boac_departments'
require_relative '../models/boac/filtered_cohort'
require_relative '../models/boac/note_source'
require_relative '../models/boac/note_template'
require_relative '../models/boac/note'
require_relative '../models/boac/note_batch'
require_relative '../models/boac/team'
require_relative '../models/boac/squad'
require_relative '../models/boac/topic'
require_relative '../models/course'
require_relative '../models/analytics/event'
require_relative '../models/analytics/event_type'
require_relative '../models/section'
require_relative '../models/lti_tools'
require_relative '../models/canvas/announcement'
require_relative '../models/canvas/assignment'
require_relative '../models/canvas/discussion'
require_relative '../models/canvas/group'
require_relative '../models/oec/oec_departments'
require_relative '../models/suitec/activity'
require_relative '../models/suitec/asset'
require_relative '../models/suitec/comment'
require_relative '../models/suitec/whiteboard'

require_relative 'utils'
require_relative 'boac_utils'
require_relative 'junction_utils'
require_relative 'lrs_utils'
require_relative 'nessie_utils'
require_relative 'oec_utils'
require_relative 'suite_c_utils'
require_relative '../models/boac/boac_test_config'
require_relative '../pages/element'
require_relative '../pages/page_object'
require_relative '../pages/page'
require_relative '../pages/page'
require_relative '../pages/oec/blue_page'
require_relative '../pages/cal_net_page'
require_relative '../pages/canvas/canvas_page'
require_relative '../pages/canvas/canvas_assignments_page'
require_relative '../pages/canvas/canvas_announce_discuss_page'
require_relative '../pages/canvas/canvas_grades_page'
require_relative '../pages/canvas/canvas_groups_page'
require_relative '../models/junction/junction_test_config'
require_relative '../pages/junction/junction_pages'
require_relative '../pages/junction/api_academics_course_provision_page'
require_relative '../pages/junction/api_academics_roster_page'
require_relative '../pages/junction/splash_page'
require_relative '../pages/junction/my_toolbox_page'
require_relative '../pages/junction/canvas_course_sections_page'
require_relative '../pages/junction/canvas_site_creation_page'
require_relative '../pages/junction/canvas_create_course_site_page'
require_relative '../pages/junction/canvas_create_project_site_page'
require_relative '../pages/junction/canvas_course_add_user_page'
require_relative '../pages/junction/canvas_course_captures_page'
require_relative '../pages/junction/canvas_rosters_page'
require_relative '../pages/junction/canvas_course_manage_sections_page'
require_relative '../pages/junction/canvas_mailing_lists_page'
require_relative '../pages/junction/canvas_mailing_list_page'
require_relative '../pages/junction/canvas_e_grades_export_page'
require_relative '../pages/boac/boac_pages'
require_relative '../pages/boac/boac_pagination'
require_relative '../pages/boac/boac_pages_create_note_modal'
require_relative '../pages/boac/boac_admit_pages'
require_relative '../pages/boac/boac_admit_list_pages'
require_relative '../pages/boac/boac_student_page_timeline'
require_relative '../pages/boac/boac_group_modal_pages'
require_relative '../pages/boac/boac_add_group_selector_pages'
require_relative '../pages/boac/boac_appt_intake_desk'
require_relative '../pages/boac/boac_appt_intake_desk_page'
require_relative '../pages/boac/boac_list_view_pages'
require_relative '../pages/boac/boac_user_list_pages'
require_relative '../pages/boac/boac_home_page'
require_relative '../pages/boac/boac_cohort_pages'
require_relative '../pages/boac/boac_class_pages'
require_relative '../pages/boac/boac_class_list_view_page'
require_relative '../pages/boac/boac_class_matrix_view_page'
require_relative '../pages/boac/boac_group_page'
require_relative '../pages/boac/boac_filtered_cohort_page_filters'
require_relative '../pages/boac/boac_filtered_cohort_page_results'
require_relative '../pages/boac/boac_filtered_cohort_page'
require_relative '../pages/boac/boac_filtered_admits_page'
require_relative '../pages/boac/boac_filtered_cohort_history_page'
require_relative '../pages/boac/boac_flight_data_recorder_page'
require_relative '../pages/boac/boac_flight_deck_page'
require_relative '../pages/boac/boac_pax_manifest_page'
require_relative '../pages/boac/boac_search_results_page'
require_relative '../pages/boac/boac_student_page_advising_note'
require_relative '../pages/boac/boac_student_page_appointment'
require_relative '../pages/boac/boac_student_page'
require_relative '../pages/boac/boac_admit_page'
require_relative '../pages/boac/boac_api_admin_page'
require_relative '../pages/boac/boac_api_admit_page'
require_relative '../pages/boac/boac_api_notes_page'
require_relative '../pages/boac/boac_api_section_page'
require_relative '../pages/boac/boac_api_student_page'
require_relative '../pages/suitec/suite_c_pages'
require_relative '../pages/suitec/asset_library_list_view_page'
require_relative '../pages/suitec/asset_library_detail_page'
require_relative '../pages/suitec/asset_library_manage_assets_page'
require_relative '../pages/suitec/engagement_index_page'
require_relative '../pages/suitec/engagement_index_config_page'
require_relative '../pages/suitec/whiteboard_list_view_page'
require_relative '../pages/suitec/whiteboard_page'
require_relative '../pages/suitec/impact_studio_page'
