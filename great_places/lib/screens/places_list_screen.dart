import 'package:flutter/material.dart';
import '../providers/great_places.dart';
import 'package:provider/provider.dart';
import 'add_place_screen.dart';

class PlacesListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('your Places'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(AddPlaceScreen.routeName);
            },
          )
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<GreatPlaces>(context, listen: false)
            .fetchAndSetPlaces(),
        builder: (context, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Consumer<GreatPlaces>(
                child: Center(
                  child: const Text('Got no places yet, start adding some!'),
                ),
                builder: (ctx, value, child) => value.items.length <= 0
                    ? child
                    : ListView.builder(
                        itemBuilder: (ctx, index) => ListTile(
                          title: Text(value.items[index].title),
                          leading: CircleAvatar(
                            backgroundImage:
                                FileImage(value.items[index].image),
                          ),
                          onTap: () {
                            // Go to detail page
                          },
                        ),
                        itemCount: value.items.length,
                      ),
              ),
      ),
    );
  }
}
