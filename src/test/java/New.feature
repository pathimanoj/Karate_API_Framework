And def importResponse = response

* def alias_name = response.files[0].alias_name
* print alias_name
* match alias_name == 'v4'

* def files_url = response.files[0].url
* match files_url == 'https://s3-eu-west-1.amazonaws.com/dp-publish-content-test/OCIGrowth.csv'

And print importResponse

* def job_id = response.job_id
* def instance_ids = response.links.instance_ids[0]

* print instance_ids

   #And match response[*].files[0].alias_name contains ['v4']