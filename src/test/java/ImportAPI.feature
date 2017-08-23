Feature: An API used to create and query information about import jobs

  This API is seperated into two parts;

  The external interface is used by florence to create and query for information about an import job
  The internal interface is used by services which are processing the import job. The services will use this API
  to update the state and add events to the job.

  Background:
    Given url 'http://localhost:21800/'

  Scenario: Import job end to end

    #/** 201 - An import job was successfully created */
    * def createJobJsonRequest = read('payload.json')

    Given path 'jobs'
    #And request { "recipe": "hello", "state": "new", "files": [ { "alias_name": "v4", "url": "https://s3-eu-west-1.amazonaws.com/dp-publish-content-test/OCIGrowth.csv" } ] } }
    And request createJobJsonRequest
    When method post
    Then status 201

    And match response contains { job_id: '#notnull', recipe: 'hello' , state: 'new'}
    And match response.recipe == createJobJsonRequest.recipe
    And match response.state == createJobJsonRequest.state

    And match response.files[0].url == 'https://s3-eu-west-1.amazonaws.com/dp-publish-content-test/OCIGrowth.csv'
    And match response.files[0].url == createJobJsonRequest.files[0].url

    And match response.files[0].alias_name == 'v4'
    And match response.files[0].alias_name == createJobJsonRequest.files[0].alias_name

    #And match response.instances[0].instance_ids[*] == '#notnull'
    And match response.instances[0].id == '#notnull'
    And match response.instances[0].link == '#notnull'
    #And match response contains { job_id: '#notnull', recipe: 'hello' , state: 'new'}
    And def job_id = response.job_id

    #/*  200 - The job is in a queue */
    Given path 'jobs/' + job_id
    And request read('payload1.json')
    When method put
    Then status 200

    #/*  200 - The file was added to the import job */
    Given path 'jobs/' + job_id + '/files'
    And request { "alias_name": "v4",  "url": "https://s3-eu-west-1.amazonaws.com/dp-publish-content-test/OCIGrowth.csv" }
    When method put
    Then status 200






