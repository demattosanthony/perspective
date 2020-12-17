import 'package:flutter/material.dart';
import 'package:point_of_view/core/enums/viewstate.dart';
import 'package:point_of_view/core/services/ApiService.dart';

import 'package:point_of_view/core/viewmodels/base_model.dart';
import 'package:point_of_view/locator.dart';
import '../models/Event.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'dart:math';
import 'package:image_picker/image_picker.dart';

const kGoogleApiKey = 'AIzaSyBPNfS9u4Tz6F8CTR2WXNj1TJfdamSqHLY';
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

class CreateAlbumModel extends BaseModel {
  final ApiService _apiService = locator<ApiService>();

  Event event;
  TextEditingController _albumTitleController = new TextEditingController();
  Mode _mode = Mode.overlay;
  String _selectedLocation;
  String _locationAddress;

  String latitude;
  String longitude;

  TextEditingController get albumTitleController => _albumTitleController;

  String get selectedLocation => _selectedLocation;
  String get locationAddress => _locationAddress;

  String _image;
  String get image => _image;

  final picker = ImagePicker();

  Future getImage() async {
    setState(ViewState.Busy);
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _image = pickedFile.path;
    } else {
      print('No image selected.');
    }
    setState(ViewState.Idle);
  }

  void uploadImage(String eventId) async {
    setState(ViewState.Busy);
    //_firebaseStorageService.uploadImage(
    //  _image, 'event_images/${_eventTextFieldController.text}', eventId);
    setState(ViewState.Idle);
  }

  Future<String> createAlbum() async {
    setState(ViewState.Busy);

    var shareString = await _apiService.createAlbum(_albumTitleController.text);
    await _apiService.getAlbums();

    setState(ViewState.Idle);
    return shareString;
  }

  final border = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(90.0)),
      borderSide: BorderSide(
        color: Colors.transparent,
      ));

  Future<List> addLocationButton(BuildContext context) async {
    setState(ViewState.Busy);
    // show input autocomplete with selected mode
    // then get the Prediction selected

    Prediction p = await PlacesAutocomplete.show(
      context: context,
      apiKey: kGoogleApiKey,
      mode: _mode,
      language: "us",
      components: [Component(Component.country, "us")],
    );

    PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(p.placeId);
    final lat = detail.result.geometry.location.lat;
    final lng = detail.result.geometry.location.lng;
    final addr = detail.result.formattedAddress;

    print(p.description);
    latitude = lat.toString();
    longitude = lng.toString();
    _selectedLocation = p.description.toString();
    _locationAddress = addr;

    setState(ViewState.Idle);

    print(addr);

    print('$lat $lng');
    return [lat, lng];

    //displayPrediction(p, homeScaffoldKey.currentState);
  }

  void navigateToEventPreview(BuildContext context, String image) {
    Event event = Event(
        latitude: latitude,
        longitude: longitude,
        locationTitle: _selectedLocation,
        address: _locationAddress,
        image: image,
        title: _albumTitleController.text,
        id: '1');
  }
}

Future<Null> displayPrediction(Prediction p, ScaffoldState scaffold) async {
  if (p != null) {
    // get detail (lat/lng)
    PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(p.placeId);
    final lat = detail.result.geometry.location.lat;
    final lng = detail.result.geometry.location.lng;

    scaffold.showSnackBar(
      SnackBar(content: Text("${p.description} - $lat/$lng")),
    );
  }
}

final searchScaffoldKey = GlobalKey<ScaffoldState>();

// custom scaffold that handle search
// basically your widget need to extends [GooglePlacesAutocompleteWidget]
// and your state [GooglePlacesAutocompleteState]
class CustomSearchScaffold extends PlacesAutocompleteWidget {
  CustomSearchScaffold()
      : super(
          apiKey: kGoogleApiKey,
          sessionToken: Uuid().generateV4(),
          language: "en",
          components: [Component(Component.country, "uk")],
        );

  @override
  _CustomSearchScaffoldState createState() => _CustomSearchScaffoldState();
}

class _CustomSearchScaffoldState extends PlacesAutocompleteState {
  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(title: AppBarPlacesAutoCompleteTextField());
    final body = PlacesAutocompleteResult(
      onTap: (p) {
        displayPrediction(p, searchScaffoldKey.currentState);
      },
      logo: Row(
        children: [FlutterLogo()],
        mainAxisAlignment: MainAxisAlignment.center,
      ),
    );
    return Scaffold(key: searchScaffoldKey, appBar: appBar, body: body);
  }

  @override
  void onResponseError(PlacesAutocompleteResponse response) {
    super.onResponseError(response);
    searchScaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text(response.errorMessage)),
    );
  }

  @override
  void onResponse(PlacesAutocompleteResponse response) {
    super.onResponse(response);
    if (response != null && response.predictions.isNotEmpty) {
      searchScaffoldKey.currentState.showSnackBar(
        SnackBar(content: Text("Got answer")),
      );
    }
  }
}

class Uuid {
  final Random _random = Random();

  String generateV4() {
    // Generate xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx / 8-4-4-4-12.
    final int special = 8 + _random.nextInt(4);

    return '${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}-'
        '${_bitsDigits(16, 4)}-'
        '4${_bitsDigits(12, 3)}-'
        '${_printDigits(special, 1)}${_bitsDigits(12, 3)}-'
        '${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}';
  }

  String _bitsDigits(int bitCount, int digitCount) =>
      _printDigits(_generateBits(bitCount), digitCount);

  int _generateBits(int bitCount) => _random.nextInt(1 << bitCount);

  String _printDigits(int value, int count) =>
      value.toRadixString(16).padLeft(count, '0');
}
