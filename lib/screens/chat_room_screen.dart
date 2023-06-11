import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/message.dart';
import '../providers/user_provider.dart';
import '../providers/ride_requests_provider.dart';
import '../providers/chat_room_provider.dart';

import '../screens/confirm_ride_screen.dart';
import '../widgets/google_maps.dart';
import '../widgets/small_loading.dart';

class ChatRoomScreen extends StatefulWidget {
  static const String routeName = '/chat-room';

  const ChatRoomScreen({super.key});

  @override
  _ChatRoomScreenState createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final TextEditingController _textController = TextEditingController();
  bool _loading = false;
  bool _firstTime = true;

  @override
  void didChangeDependencies() {
    if (_firstTime) {
      Provider.of<ChatRoomProvider>(
        context,
        listen: false,
      ).connectSocket();

      Provider.of<ChatRoomProvider>(
        context,
        listen: false,
      ).receiveMessage();

      Provider.of<ChatRoomProvider>(
        context,
        listen: false,
      ).receiveStartRideRequest(context);

      _firstTime = false;
    }
    super.didChangeDependencies();
  }

  void _handleSubmitted(String text) async {
    if (text.isEmpty) return;

    setState(() {
      _loading = true;
    });

    _textController.clear();
    final _userType =
        Provider.of<UserProvider>(context, listen: false).currentType;

    final _userName =
        Provider.of<UserProvider>(context, listen: false).userName;

    final _receiverName =
        Provider.of<ChatRoomProvider>(context, listen: false).receiverName;
    // final _receiverName = "saaaadi16";

    // Provider.of<ChatRoomProvider>(context, listen: false)
    //     .addMessage(_userName, text, _userType);
    try {
      await Provider.of<ChatRoomProvider>(context, listen: false).sendMessage(
          '$_receiverName/chat/message', _userName, _userType, text);
    } catch (e) {
      print(e.toString());
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Widget _buildTextComposer() {
    return Container(
      // padding: EdgeInsets.symmetric(horizontal: 8.0),
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: <Widget>[
          Flexible(
            // fit: FlexFit.loose,
            // flex: 5,
            child: TextField(
              controller: _textController,
              onSubmitted: _handleSubmitted,
              decoration: InputDecoration.collapsed(hintText: 'Send a message'),
            ),
          ),
          Container(
            // margin: EdgeInsets.symmetric(horizontal: 4.0),
            child: IconButton(
              icon: Icon(Icons.send),
              splashRadius: 1,
              onPressed: () => _handleSubmitted(_textController.text),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _messages = Provider.of<ChatRoomProvider>(context).messages;

    final bool _requestingRide =
        Provider.of<RideRequestProvider>(context).requestingRide;

    // final bool _startRide = Provider.of<ChatRoomProvider>(context).startRide;

    final _userType = Provider.of<UserProvider>(context).currentType;
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Room'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(GoogleMaps.routeName);
            },
            icon: Icon(Icons.location_on),
            splashRadius: 25,
            tooltip: "View User Location",
            padding: EdgeInsets.symmetric(horizontal: 15),
            // splashColor: Theme.of(context).accentColor,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.small(
        tooltip: "Start Ride",
        backgroundColor: Theme.of(context).accentColor,
        onPressed: () {
          if (_requestingRide) return;
          Provider.of<ChatRoomProvider>(
            context,
            listen: false,
          ).startRideRequest();

          Navigator.of(context)
              .pushReplacementNamed(ConfirmRideScreen.routeName);
        },
        child: _requestingRide && _userType == Type.passenger
            ? SmallLoading()
            : Text(
                'GO',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
        // label: Text('GO', style: TextStyle(color: Colors.white)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
      body: _requestingRide && _userType == Type.passenger
          ? Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text('Waiting for driver to accept your request'),
                ],
              ),
            )
          : Column(
              children: <Widget>[
                Flexible(
                  child: ListView.builder(
                    reverse: true,
                    padding: EdgeInsets.all(8.0),
                    itemCount: _messages.length,
                    itemBuilder: (_, int index) =>
                        _buildMessage(_messages[index], index),
                  ),
                ),
                Divider(height: 1.0),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                  ),
                  child: _buildTextComposer(),
                ),
              ],
            ),
    );
  }

  Widget _buildMessage(Message message, int index) {
    final _userType =
        Provider.of<UserProvider>(context, listen: false).currentType;

    // final _userName =
    //     Provider.of<UserProvider>(context, listen: false).userName;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        children: [
          message.user != _userType
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(right: 8.0),
                      child: CircleAvatar(
                        child: Text('${message.userName[0].toUpperCase()}'),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('${message.userName}',
                              style: Theme.of(context).textTheme.bodySmall),
                          Container(
                            margin: EdgeInsets.only(top: 5.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20.0),
                                topRight: Radius.circular(20.0),
                                // bottomLeft: Radius.circular(20.0),
                                bottomRight: Radius.circular(20.0),
                              ),
                              child: Container(
                                padding: EdgeInsets.all(10.0),
                                color: Theme.of(context)
                                    .appBarTheme
                                    .backgroundColor,
                                child: Text(message.text),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text('${message.userName}',
                              style: Theme.of(context).textTheme.bodySmall),
                          Container(
                            margin: EdgeInsets.only(top: 5.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20.0),
                                topRight: Radius.circular(20.0),
                                bottomLeft: Radius.circular(20.0),
                              ),
                              child: Container(
                                padding: EdgeInsets.all(10.0),
                                color: Theme.of(context).accentColor,
                                child: Text(message.text),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 8.0),
                          child: CircleAvatar(
                            child: Text('${message.userName[0].toUpperCase()}'),
                          ),
                        ),
                        Container(
                          // margin: EdgeInsets.only(right: _loading ? 4.0 : 0.0),
                          child: index == 0
                              ? Container(
                                  margin: EdgeInsets.only(top: 2),
                                  height: 12,
                                  width: 12,
                                  child: _loading
                                      ? CircularProgressIndicator(
                                          strokeWidth: 1,
                                          color: Theme.of(context)
                                              .appBarTheme
                                              .backgroundColor,
                                        )
                                      : Icon(
                                          Icons.check_circle,
                                          size: 15,
                                          color: Color.fromARGB(
                                              172, 131, 131, 131),
                                        ),
                                )
                              : const SizedBox(),
                        ),
                      ],
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}
