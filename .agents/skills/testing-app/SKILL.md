# Testing the Restaurant Website

## Build & Run
```bash
docker build -t restaurent-website .
docker run -d --name restaurent-test -p 8080:80 restaurent-website
```

## Key Test Points
- Main page is `menu.html` (not index.html) — nginx.conf maps `/` to `menu.html`
- Security headers must appear on BOTH document and static asset responses (nginx `add_header` inheritance gotcha)
- Hidden files (e.g. `/.env`, `/.git`) should return 403
- Unknown paths should return 404 (not fallback to menu.html)
- `Server` header should show `nginx` without version number

## Verify Commands
```bash
# Site loads
curl -s -o /dev/null -w "%{http_code}" http://localhost:8080/
# Security headers on document
curl -sI http://localhost:8080/ | grep -i "x-frame-options\|x-content-type\|server"
# Security headers on static assets (critical — nginx add_header inheritance)
curl -sI http://localhost:8080/styles.css | grep -i "x-frame-options\|cache-control"
# 404 handling
curl -s -o /dev/null -w "%{http_code}" http://localhost:8080/nonexistent
# Hidden file protection
curl -s -o /dev/null -w "%{http_code}" http://localhost:8080/.env
```

## Known Pre-existing Issues
- Grid images in "Our Menu" section are broken — `menu.html` references `images/grid_image1.png` but files are in the root directory

## Cleanup
```bash
docker rm -f restaurent-test
```
