# City Stats

Considering various places you might move to? This tool can help.

This app uses the [Open Data Network](https://www.opendatanetwork.com/) to look up statistics about various cities. You can compare any number of cities and download your data as a CSV. Once you have your CSV, you can set up color scales and take notes on the various cities.

[GitHub](https://github.com/DawnPaladin/apartment_hunter) / [Heroku](http://evening-savannah-75702.herokuapp.com/)

## Setting up your own copy

If you clone this app, you'll need to set to set up your own API key. [Set up an account with Socrata](https://dev.socrata.com/register), then create config/application.yml like so:

```
SOCRATA_APP_TOKEN: your_token
```
