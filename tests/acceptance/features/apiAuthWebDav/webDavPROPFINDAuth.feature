@api
Feature: get file info using PROPFIND

  Background:
    Given user "Alice" has been created with default attributes and without skeleton files
    And user "Alice" has uploaded file with content "some data" to "/textfile0.txt"
    And user "Alice" has created folder "/PARENT"
    And user "Alice" has created folder "/FOLDER"
    And user "Alice" has uploaded file with content "some data" to "/PARENT/parent.txt"
    And user "Brian" has been created with default attributes and without skeleton files

  @smokeTest
  @skipOnBruteForceProtection @issue-brute_force_protection-112
  Scenario: send PROPFIND requests to webDav endpoints as normal user with wrong password
    When user "Alice" requests these endpoints with "PROPFIND" including body using password "invalid" then the status codes about user "Alice" should be as listed
      | endpoint                                           | http-code | body          |
      | /remote.php/webdav/textfile0.txt                   | 401       | doesnotmatter |
      | /remote.php/dav/files/%username%/textfile0.txt     | 401       | doesnotmatter |
      | /remote.php/webdav/PARENT                          | 401       | doesnotmatter |
      | /remote.php/dav/files/%username%/PARENT            | 401       | doesnotmatter |
      | /remote.php/dav/files/%username%/PARENT/parent.txt | 401       | doesnotmatter |

  @smokeTest
  @skipOnBruteForceProtection @issue-brute_force_protection-112
  Scenario: send PROPFIND requests to webDav endpoints as normal user with no password
    When user "Alice" requests these endpoints with "PROPFIND" including body using password "" then the status codes about user "Alice" should be as listed
      | endpoint                                           | http-code | body          |
      | /remote.php/webdav/textfile0.txt                   | 401       | doesnotmatter |
      | /remote.php/dav/files/%username%/textfile0.txt     | 401       | doesnotmatter |
      | /remote.php/webdav/PARENT                          | 401       | doesnotmatter |
      | /remote.php/dav/files/%username%/PARENT            | 401       | doesnotmatter |
      | /remote.php/dav/files/%username%/PARENT/parent.txt | 401       | doesnotmatter |

  @skipOnOcis @issue-ocis-reva-9
  Scenario: send PROPFIND requests to another user's webDav endpoints as normal user
    When user "Brian" requests these endpoints with "PROPFIND" including body then the status codes about user "Alice" should be as listed
      | endpoint                                           | http-code | body                                                                                                                           |
      | /remote.php/dav/files/%username%/textfile0.txt     | 404       | <?xml version="1.0"?><d:propfind  xmlns:d="DAV:" xmlns:oc="http://owncloud.org/ns"><d:prop><d:getetag /></d:prop></d:propfind> |
      | /remote.php/dav/files/%username%/PARENT            | 404       | <?xml version="1.0"?><d:propfind  xmlns:d="DAV:" xmlns:oc="http://owncloud.org/ns"><d:prop><d:getetag /></d:prop></d:propfind> |
      | /remote.php/dav/files/%username%/PARENT/parent.txt | 404       | <?xml version="1.0"?><d:propfind  xmlns:d="DAV:" xmlns:oc="http://owncloud.org/ns"><d:prop><d:getetag /></d:prop></d:propfind> |

  @skipOnOcV10 @issue-ocis-reva-9
  #after fixing all issues delete this Scenario and use the one above
  Scenario: send PROPFIND requests to another user's webDav endpoints as normal user
    When user "Brian" requests these endpoints with "PROPFIND" including body then the status codes about user "Alice" should be as listed
      | endpoint                                           | http-code | body                                                                                                                           |
      | /remote.php/dav/files/%username%/textfile0.txt     | 207       | <?xml version="1.0"?><d:propfind  xmlns:d="DAV:" xmlns:oc="http://owncloud.org/ns"><d:prop><d:getetag /></d:prop></d:propfind> |
      | /remote.php/dav/files/%username%/PARENT            | 207       | <?xml version="1.0"?><d:propfind  xmlns:d="DAV:" xmlns:oc="http://owncloud.org/ns"><d:prop><d:getetag /></d:prop></d:propfind> |
      | /remote.php/dav/files/%username%/PARENT/parent.txt | 207       | <?xml version="1.0"?><d:propfind  xmlns:d="DAV:" xmlns:oc="http://owncloud.org/ns"><d:prop><d:getetag /></d:prop></d:propfind> |

  Scenario: send PROPFIND requests to webDav endpoints using invalid username but correct password
    When user "usero" requests these endpoints with "PROPFIND" including body using the password of user "Alice" then the status codes should be as listed
      | endpoint                                           | http-code | body          |
      | /remote.php/webdav/textfile0.txt                   | 401       | doesnotmatter |
      | /remote.php/dav/files/%username%/textfile0.txt     | 401       | doesnotmatter |
      | /remote.php/webdav/PARENT                          | 401       | doesnotmatter |
      | /remote.php/dav/files/%username%/PARENT            | 401       | doesnotmatter |
      | /remote.php/dav/files/%username%/PARENT/parent.txt | 401       | doesnotmatter |

  Scenario: send PROPFIND requests to webDav endpoints using valid password and username of different user
    When user "Brian" requests these endpoints with "PROPFIND" including body using the password of user "Alice" then the status codes should be as listed
      | endpoint                                           | http-code | body          |
      | /remote.php/webdav/textfile0.txt                   | 401       | doesnotmatter |
      | /remote.php/dav/files/%username%/textfile0.txt     | 401       | doesnotmatter |
      | /remote.php/webdav/PARENT                          | 401       | doesnotmatter |
      | /remote.php/dav/files/%username%/PARENT            | 401       | doesnotmatter |
      | /remote.php/dav/files/%username%/PARENT/parent.txt | 401       | doesnotmatter |

  @smokeTest
  @skipOnBruteForceProtection @issue-brute_force_protection-112
  Scenario: send PROPFIND requests to webDav endpoints without any authentication
    When a user requests these endpoints with "PROPFIND" and no authentication then the status codes about user "Alice" should be as listed
      | endpoint                                           | http-code | body          |
      | /remote.php/webdav/textfile0.txt                   | 401       | doesnotmatter |
      | /remote.php/dav/files/%username%/textfile0.txt     | 401       | doesnotmatter |
      | /remote.php/webdav/PARENT                          | 401       | doesnotmatter |
      | /remote.php/dav/files/%username%/PARENT            | 401       | doesnotmatter |
      | /remote.php/dav/files/%username%/PARENT/parent.txt | 401       | doesnotmatter |

  @skipOnOcis @issue-ocis-reva-37
  Scenario: send PROPFIND requests to webDav endpoints using token authentication should not work
    Given token auth has been enforced
    And a new browser session for "Alice" has been started
    And the user has generated a new app password named "my-client"
    When the user requests these endpoints with "PROPFIND" using the generated app password then the status codes about user "Alice" should be as listed
      | endpoint                                           | http-code |
      | /remote.php/webdav/textfile0.txt                   | 401       |
      | /remote.php/dav/files/%username%/textfile0.txt     | 401       |
      | /remote.php/webdav/PARENT                          | 401       |
      | /remote.php/dav/files/%username%/PARENT            | 401       |
      | /remote.php/dav/files/%username%/PARENT/parent.txt | 401       |

  @skipOnOcis @issue-ocis-reva-37
  Scenario: send PROPFIND requests to webDav endpoints using app password token as password
    Given token auth has been enforced
    And a new browser session for "Alice" has been started
    And the user has generated a new app password named "my-client"
    When the user "Alice" requests these endpoints with "PROPFIND" using the basic auth and generated app password then the status codes about user "Alice" should be as listed
      | endpoint                                           | http-code | body                                                                                                                           |
      | /remote.php/dav/files/%username%/textfile0.txt     | 207       | <?xml version="1.0"?><d:propfind  xmlns:d="DAV:" xmlns:oc="http://owncloud.org/ns"><d:prop><d:getetag /></d:prop></d:propfind> |
      | /remote.php/dav/files/%username%/PARENT            | 207       | <?xml version="1.0"?><d:propfind  xmlns:d="DAV:" xmlns:oc="http://owncloud.org/ns"><d:prop><d:getetag /></d:prop></d:propfind> |
      | /remote.php/dav/files/%username%/PARENT/parent.txt | 207       | <?xml version="1.0"?><d:propfind  xmlns:d="DAV:" xmlns:oc="http://owncloud.org/ns"><d:prop><d:getetag /></d:prop></d:propfind> |
      | /remote.php/webdav/PARENT                          | 207       | <?xml version="1.0"?><d:propfind  xmlns:d="DAV:" xmlns:oc="http://owncloud.org/ns"><d:prop><d:getetag /></d:prop></d:propfind> |
      | /remote.php/webdav/textfile0.txt                   | 207       | <?xml version="1.0"?><d:propfind  xmlns:d="DAV:" xmlns:oc="http://owncloud.org/ns"><d:prop><d:getetag /></d:prop></d:propfind> |
