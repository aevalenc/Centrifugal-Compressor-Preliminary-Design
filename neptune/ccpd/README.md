# ccpd
This is the main application of the Neptune project. Here we have the django `views.py` file where all the pages for the Neptune project are defined. This is essentially the backend of the project (I think)

# Schema
```
ccpd (<b>application<\b>)
|
|--urls.py
|  -- paths to the individual views link
|
|--views.py
|  -- Where the definition of the http response functions are located. The `manage.py` will call the urls.py of the web application. This will
|     re-route to the `urls.py` of this directory which in turn will search for a function within this file
|
|--templates
|  -- A directory where django will look for html templates for the web application. Within templates, there is another directory with the same
|     name as current application directory
```
