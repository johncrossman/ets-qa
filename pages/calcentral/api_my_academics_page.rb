require_relative '../../util/spec_helper'

class ApiMyAcademicsPage

  include PageObject
  include Logging

  def get_feed(driver)
    logger.info 'Parsing data from /api/my/academics'
    navigate_to "#{Utils.calcentral_base_url}/api/my/academics"
    wait_until(Utils.long_wait) { driver.find_element(xpath: '//pre') }
    @parsed = JSON.parse driver.find_element(xpath: '//pre').text
  end

  # SEMESTERS

  def all_student_semesters
    @parsed['semesters']
  end

  def all_teaching_semesters
    @parsed['teachingSemesters']
  end

  def semesters_in_time_bucket(semesters, time_bucket)
    semesters.select { |semester| semester['timeBucket'] == time_bucket }
  end

  def current_semester(semesters)
    semesters && semesters_in_time_bucket(semesters, 'current')[0]
  end

  def future_semesters(semesters)
    semesters_in_time_bucket(semesters, 'future')
  end

  def semester_name(semester)
    semester['name']
  end

  # COURSES

  def semester_courses(semester)
    semester['classes']
  end

  def course_title(course)
    course['title'].nil? ? '' : (course['title'].gsub(/\s+/, ' ')).strip
  end

  def course_url(course)
    course['url']
  end

  def multiple_primaries?(course)
    course['multiplePrimaries']
  end

  # SECTIONS

  def course_primary_sections(course)
    course['sections'].map { |section| section if section['is_primary_section'] }
  end

  def section_url(section)
    section['url']
  end

  # COURSE SITES

  def section_side_ids(section)
    section['siteIds']
  end

  def course_sites(course)
    course['class_sites']
  end

  def course_site_id(course_site)
    course_site['id']
  end

  def course_site_url(course_site)
    course_site['site_url']
  end

  def course_site_name(course_site)
    course_site['name'] && course_site['name'].strip.gsub('  ', ' ')
  end

  def course_site_names(course)
    course_sites(course).map { |site| course_site_name(site) } unless course_sites(course).nil?
  end

  def semester_course_site_names(semester_courses)
    name = semester_courses.map { |course| course_site_names course }
    name.flatten.compact
  end

  def course_site_descrip(course_site)
    course_site['shortDescription'] && course_site['shortDescription'].strip.gsub('  ', ' ')
  end

  def course_site_descrips(course)
    descriptions = []
    unless course_sites(course).nil?
      course_sites(course).each do |site|
        unless course_site_descrip(site).nil? || course_site_descrip(site) == course_site_name(site) || course_site_descrip(site) == course_title(course)
          descriptions << course_site_descrip(site)
        end
      end
    end
    descriptions
  end

  def semester_course_site_descrips(semester_courses)
    descriptions = semester_courses.map { |course| course_site_descrips(course) }
    descriptions.flatten.compact
  end

  # OTHER SITE MEMBERSHIPS

  def other_site_memberships
    @parsed['otherSiteMemberships']
  end

  def other_sites(semester_name)
    sites = other_site_memberships && other_site_memberships.map { |memb| memb['sites'] if memb['name'] == semester_name }
    sites.to_a.flatten.compact
  end

  def other_site_names(sites)
    sites.map { |site| site['name'] }
  end

  def other_site_descriptions(sites)
    sites.map { |site| site['shortDescription'].gsub(/\s+/, ' ') }
  end

end