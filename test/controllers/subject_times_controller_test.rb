# frozen_string_literal: true

require 'test_helper'

class SubjectTimesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @subject_time = subject_times(:one)
  end

  test 'should get time' do
    token = sign_in_as_customer
    get subject_times_time_url(group_id: @subject_time.group_id, subject_id: @subject_time.subject_id),
        headers: { Authorization: token }, as: :json
    assert_response :success
  end

  test 'should update subject_time' do
    token = sign_in_as_admin
    patch subject_times_url,
          params: { subject_times: [{ group_id: @subject_time.group_id, subject_id: @subject_time.subject_id,
                                      time: '14:10' }] }, headers: { Authorization: token }, as: :json
    assert_response :success
    date = Date.new(2000, 1, 1)
    time_zone = 'UTC'
    assert_equal DateTime.new(date.year, date.month, date.day,
                              '14:10'[0..1].to_i, '14:10'[3..4].to_i, 0,
                              time_zone), @subject_time.reload.time
  end

  test 'should not update subject_time' do
    token = sign_in_as_customer
    patch subject_times_url,
          params: { subject_times: [{ group_id: @subject_time.group_id, subject_id: @subject_time.subject_id,
                                      time: '14:10' }] }, headers: { Authorization: token }, as: :json
    assert_response :forbidden
    assert_not_equal '14:10', @subject_time.reload.time
  end
end
