Feature: RESTful API for folders

  Background:
    Given Doctor Who is a user with a home folder
    And Doctor Who sign-in to the gridfs navigator

  Scenario: create a new folder
    Given Dr. Who's home folder is empty
    And a GET request to "/api/folders.json" returns an empty "folder"
    When I POST this "folder" JSON to "/api/folders.json":
      """
      {
        "folder": {
          "name": "new_folder"
        }
      }
      """
    Then a GET request to "/api/folders.json" should include the following "folder":
      """
      {
        "name": "new_folder"
      }
      """
