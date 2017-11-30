# Django on Director

Director species which port you can serve on, among other things. Here is a checklist of Director-specific things (some of these can be applied to other services, like Heroku).

- [ ] You use `$PORT` to specify the port (e.g. `./manage.py runserver $PORT`)
- [ ] You have a `run.sh` file with the service you're running.
- [ ] You are accessing the site through <your-site-name>.sites.tjhsst.edu

```bash
# run.sh
python manage.py runserver $PORT
```
