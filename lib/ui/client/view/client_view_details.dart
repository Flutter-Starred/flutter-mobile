import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:invoiceninja/data/models/models.dart';
import 'package:invoiceninja/utils/formatting.dart';
import 'package:invoiceninja/utils/localization.dart';
import 'package:invoiceninja/utils/platforms.dart';
import 'package:url_launcher/url_launcher.dart';

class ClientViewDetails extends StatefulWidget {
  ClientViewDetails({this.client});

  final ClientEntity client;

  @override
  _ClientViewDetailsState createState() => new _ClientViewDetailsState();
}

class _ClientViewDetailsState extends State<ClientViewDetails> {
  Future<Null> _launched;

  Future<Null> _launchURL(BuildContext context, String url) async {
    var localization = AppLocalization.of(context);
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: false, forceWebView: false);
    } else {
      throw '${localization.couldNotLaunch}';
    }
  }

  Widget _launchStatus(BuildContext context, AsyncSnapshot<Null> snapshot) {
    var localization = AppLocalization.of(context);
    if (snapshot.hasError) {
      return new Text('${localization.error}: ${snapshot.error}');
    } else {
      return const Text('');
    }
  }

  @override
  Widget build(BuildContext context) {
    var localization = AppLocalization.of(context);
    var client = widget.client;

    _buildDetailsList() {
      var listTiles = <Widget>[];

      listTiles
          .add(FutureBuilder<Null>(future: _launched, builder: _launchStatus));

      var contacts = client.contacts;
      contacts.forEach((contact) {
        if ((contact.email ?? '').isNotEmpty) {
          listTiles.add(AppListTile(
            icon: Icons.email,
            title: contact.fullName() + '\n' + contact.email,
            copyValue: contact.email,
            subtitle: localization.email,
            onTap: () => setState(() {
                  _launched = _launchURL(context, 'mailto:' + contact.email);
                }),
          ));
        }

        if ((contact.phone ?? '').isNotEmpty) {
          listTiles.add(AppListTile(
            icon: Icons.phone,
            title: contact.fullName() + '\n' + contact.phone,
            copyValue: contact.phone,
            subtitle: localization.phone,
            onTap: () => setState(() {
                  _launched =
                      _launchURL(context, 'sms:' + cleanPhoneNumber(contact.phone));
                  //_launched = _launchURL('tel:' + cleanPhoneNumber(contact.phone));
                }),
          ));
        }
      });

      if ((client.website ?? '').isNotEmpty) {
        listTiles.add(AppListTile(
          icon: Icons.link,
          title: client.website,
          subtitle: localization.website,
          onTap: () => setState(() {
                _launched = _launchURL(context, formatURL(client.website));
              }),
        ));
      }

      if ((client.workPhone ?? '').isNotEmpty) {
        listTiles.add(AppListTile(
          icon: Icons.phone,
          title: client.workPhone,
          subtitle: localization.phone,
          onTap: () => setState(() {
                _launched =
                    _launchURL(context, 'sms:' + cleanPhoneNumber(client.workPhone));
                //_launched = _launchURL('tel:' + cleanPhoneNumber(client.workPhone));
              }),
        ));
      }

      if (listTiles.length > 0) {
        listTiles.add(Divider());
      }

      if ((client.vatNumber ?? '').isNotEmpty) {
        listTiles.add(AppListTile(
          icon: Icons.location_city,
          title: client.vatNumber,
          subtitle: localization.vatNumber,
        ));
      }

      if ((client.idNumber ?? '').isNotEmpty) {
        listTiles.add(AppListTile(
          icon: Icons.business,
          title: client.idNumber,
          subtitle: localization.idNumber,
        ));
      }

      var billingAddress = formatAddress(object: client);
      var shippingAddress = formatAddress(object: client, isShipping: true);

      if (billingAddress.isNotEmpty) {
        listTiles.add(AppListTile(
            icon: Icons.pin_drop,
            title: billingAddress,
            subtitle: localization.billingAddress,
            onTap: () {
              _launched = _launchURL(context, getMapURL(context) +
                  Uri.encodeFull(
                      formatAddress(object: client, delimiter: ',')));
            }));
      }

      if (shippingAddress.isNotEmpty) {
        listTiles.add(AppListTile(
            icon: Icons.pin_drop,
            title: shippingAddress,
            subtitle: localization.shippingAddress,
            onTap: () {
              _launched = _launchURL(context, getMapURL(context) +
                  Uri.encodeFull(formatAddress(
                      object: client, delimiter: ',', isShipping: true)));
            }));
      }

      return listTiles;
    }

    return Padding(
      padding: EdgeInsets.all(12.0),
      child: ListView(
        children: _buildDetailsList(),
      ),
    );
  }
}

class AppListTile extends StatelessWidget {
  AppListTile({
    this.icon,
    this.title,
    this.subtitle,
    this.dense = false,
    this.onTap,
    this.copyValue,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool dense;
  final Function onTap;
  final String copyValue;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.only(left: 12.0, top: 8.0, bottom: 8.0),
      leading: Icon(icon),
      title: Text(title),
      subtitle: subtitle == null ? Container() : Text(subtitle),
      dense: dense,
      onTap: onTap,
      onLongPress: () {
        Clipboard.setData(ClipboardData(text: copyValue ?? title));
        Scaffold.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalization.of(context).copiedToClipboard)));
      },
    );
  }
}
