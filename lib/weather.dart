import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart'as http;
import 'package:intl/intl.dart';
import 'package:weather/constants/constrains.dart' as constant;

class Weather extends StatefulWidget {
  const Weather({super.key});

  @override
  State<Weather> createState() => _WeatherState();
}

class _WeatherState extends State<Weather> {
  String city='';
  String discription='';
  num ?temp ;
  num ? humidity ;
  num ? pressure;
  bool isLoaded=false;
  String day = DateTime.now().toString();
  DateTime now = DateTime. now();
  String formattedDate='';

  void initState() {
    super.initState();
    getCurrentLocation();
    formattedDate = DateFormat('EEEE, MMM d, yyyy').format(now);

  }
  getCurrentLocation()async{
    var position =await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.low,
      forceAndroidLocationManager: true,
    );
    print(position);
    if(position!=null){
      print('lat:${position.latitude},long:${position.longitude}');
      getCurrentCityWeather(position);
    }
    else{
      print("Data Unavailable");
    }

  }
  getCurrentCityWeather(Position pos)async{
    var url='${constant.domain}lat=${pos.latitude}&lon=${pos.longitude}&appid=${constant.apikey}';
    var uri=Uri.parse(url);
    var responce=await http.get(uri);
    if(responce.statusCode==200){
      var data=responce.body;
      var decodedData=jsonDecode(data);
      print(data);
      updateUI(decodedData);
      setState(() {
        isLoaded=true;
      });
    }else{
      print(responce.statusCode);
    }
  }
  updateUI(var decodedData){
    setState(() {
      if(decodedData==null){
        city="Note available";
        temp=0;
        humidity=0;
        pressure=0;
        discription="Note Available";
      }else{
        temp=decodedData['main']['temp']-273;
        city=decodedData['name'];
        humidity=decodedData['main']['humidity'];
        pressure=decodedData['main']['pressure'];
        discription=decodedData['weather'][0]['description'];

      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body:
      Container(
        width: double.maxFinite,
        decoration:BoxDecoration(
          image: DecorationImage(
              image: AssetImage("images/sky2.jpeg"),fit: BoxFit.cover
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(city,style: TextStyle(fontSize: 40,color: Colors.white,fontWeight: FontWeight.bold,fontFamily: 'Mooli'),),
                Text(formattedDate,style: TextStyle(fontSize: 30,color: Colors.white,fontWeight: FontWeight.bold,fontFamily: 'Mooli'),),
                SizedBox(height: 130,),
                Icon(Icons.cloud,color: Colors.white,size: 50,),
                Text(discription,style: TextStyle(fontSize: 30,color: Colors.white,fontWeight: FontWeight.bold),),
                SizedBox(height: 30,),
                // Row(
                //   children: [
                //     // Icon(Icons.cloud_circle,color: Colors.white,size: 50,),
                //     Text("Pressure:${pressure?.toInt()}hpa",style: TextStyle(fontSize: 30,color: Colors.white,fontWeight: FontWeight.bold),),
                //     SizedBox(width: 30,),
                //     // Icon(Icons.cloud_circle,color: Colors.white,size: 50,),
                //     Text("Humidity:${humidity?.toInt()}%",style: TextStyle(fontSize: 30,color: Colors.white,fontWeight: FontWeight.bold),),
                //   ],
                // ),
                Text("Pressure:${pressure?.toInt()}hpa",style: TextStyle(fontSize: 30,color: Colors.white,fontWeight: FontWeight.bold),),
                Text("Humidity:${humidity?.toInt()}%",style: TextStyle(fontSize: 30,color: Colors.white,fontWeight: FontWeight.bold),),


                SizedBox(height: 100,),
                Center(child: Text("${temp?.toInt()}°C",style: TextStyle(fontSize: 100,color: Colors.white,fontWeight: FontWeight.bold),)),

                



              ],
            ),
          ),
        ),
      ),


    );
  }
}