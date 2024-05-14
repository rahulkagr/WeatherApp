# README

# Project Information

- **Ruby Version:** 3.3.1
- **Rails Version:** 7.1.3

## Overview

This project provides functionality to fetch weather details based on user-provided address and pin code. The Geocoder gem is utilized to retrieve latitude and longitude coordinates from the address. Subsequently, an OpenWeather API call is made to obtain weather details for the specified location.

## Usage

- **Homepage URL:** [http://localhost:3000/](http://localhost:3000/)

### Functionality

1. Upon accessing the homepage, users are prompted to enter an address and pin code.
2. The system fetches weather details corresponding to the provided location.
3. Example Response:

```
Is this from cache? false
Temperature: 32.86 ℃
Temperature Minimum: 32.86 ℃
Temperature Maximum: 32.86 ℃
Pressure: 1007 hPa
Humidity: 21 %
Wind Speed: 1.52 meter/sec
Weather Description: clear sky
```
![Screenshot 2024-05-14 at 11 13 48 PM](https://github.com/rahulkagr/WeatherApp/assets/43814671/f7e5aa5f-0cd5-43b3-923a-e7b35a4f4adb)


The "Is this from cache?" key is a boolean value indicating whether the response is from cache or not.


---------------------------------------------------------------------------------------------------------------------