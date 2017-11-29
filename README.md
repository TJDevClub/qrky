# QRky - a Python web app

Greetings, intrepid web developer. We're going to be building a Django app today, and it's going to be a party.

> __Note__: If you're using [Director](https://director.tjhsst.edu), read [Director.md](Director.md) for important alterations.

## Step 1: create a virtual environment

A virtualenv helps sandbox Python versions, packages, and package dependencies. Create a virtualenv with

```
$ virtualenv env --python=python3
```

This creates a virtualenv inside the `env` directory, using python3 as the version of Python.

[Read more about virtualenvs](http://docs.python-guide.org/en/latest/dev/virtualenvs/#lower-level-virtualenv)

Activate the virtualenv with `source env/bin/activate`. Later, you can deactivate it with just `deactivate`.

## Step 2: installing necessary packages

After you activate your virtualenv, you should see a `(env)` thing in front of your shell prompt. This lets you know you've successfully activated it.

Now, you can install packages without worrying about overriding or screwing up packages from a different project. This also allows you to install packages locally, so you don't have to worry about not having root user.

If you see `Successfully installed django-1.11.7 pyqrcode-1.2.1 pytz-2017.3`, you have succeeded in step 2. [Congrats](http://tv.giphy.com/congrats)!

## Step 3: create your Django project

If you've installed Django, you now have access to the `django-admin` command. To start your Django project, type:

```
$ django-admin startproject qrky
```

In our case, we're calling our project qrky. Try listing the stuff in your directory with `ls`. You should now see a `qrky/` directory.

Inside that directory, you should see:

```
- manage.py
- qrky/
    - __init__.py
    - settings.py
    - urls.py
    - wsgi.py
```

`manage.py` is a helper script that lets you interact with your Django app. It's good stuff.

See [here](https://docs.djangoproject.com/en/1.11/intro/tutorial01/#creating-a-project) for what the other files are.

Congrats! You've now created your very own Django project. It's kind of useless right now, but at least it's there!

## Step 4: the hard part (actually doing stuff)

Django is organized so that every project can have multiple, modular "apps". In this way, apps are reusable and more or less self-contained (ideally - practically, this may not always be the case).

Let's create our app:

```
$ python manage.py startapp qrcode
```

What new files and directories are present now?

>    __What are migrations?__

>    Migrations are how Django keeps track of changes to the database schema. You'll see this in action more in an upcoming section.

>    For now, just know that `python manage.py makemigrations` creates migrations, and `python manage.py migrate` applies those migrations.

### Step 4a: URLs

The base URL file is `qrky/qrky/urls.py`. The project only knows about this file, and any other URL file (e.g. `qrky/qrcode/urls.py`) have to be included in this file.

Let's do that now.

```py
# qrky/qrky/urls.py

from django.conf.urls import include, url
from django.contrib import admin

import qrcode.urls as qrcode

urlpatterns = [
    url(r'^admin/', admin.site.urls),
    url(r'^', include(qrcode)) # this includes qrcode urls at the root url (/)
]
```

```py
# qrky/qrcode/urls.py

from django.conf.urls import url

from . import views

urlpatterns = [
    url(r'^$', views.index, name='index'), this renders the view at the root (/)
]
```

### Step 4b: Views

You may be wondering what the whole `views.index` deal was in the URL file. Well you're about the find out.

Django handles backend logic with _views_. These return an HTTP response. Let's write our index view.

```py
# qrky/qrcode/views.py

from django.shortcuts import render


def index(request):
    return render(request, 'qrcode/index.html')
```

That was so easy. But now you probably have another question. What does `render` do?

It renders a template. What's a template?

### Step 4c: Templates (or how to actually display stuff)

Templates are just normal files. Generally, you put them in the `templates/` directory, although it can be called whatever you want. These files are then rendered with the `render` function, and returned as an HTTP response.

In our case, our first template is just an HTML that will be shown at the web app root.

```html
<!-- qrky/templates/qrcode/index.html -->

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width" />
        <title>QRky</title>
    </head>
    <body>
        Hello.
    </body>
</html>
```

In addition, we need to add the `templates/` directory to our list of template paths in `settings.py`.

```py
# settings.py

TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': [os.path.join(BASE_DIR, 'templates')], # this is the relevant line
        'APP_DIRS': True,
        'OPTIONS': {
            'context_processors': [
                'django.template.context_processors.debug',
                'django.template.context_processors.request',
                'django.contrib.auth.context_processors.auth',
                'django.contrib.messages.context_processors.messages',
            ],
        },
    },
]
```

Now, you have a fully functional (well, not really, but at least it works) application.

## Step 5: Try running it!

If you do `python manage.py runserver`, it'll start a development server on port 8000. You _do not_ want this in production. Instead, you should use `gunicorn` or another production-level WSGI server.

That's for another day, though. For now, `runserver` is fine.
