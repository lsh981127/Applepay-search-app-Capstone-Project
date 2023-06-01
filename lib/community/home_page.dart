import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newcapstone/community/freeforum.dart';
import 'package:newcapstone/src/googleMap.dart';
import 'home_cubit.dart';
import 'package:flutter/cupertino.dart';


class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, int>(
      builder: (_, state) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Scaffold(
            bottomNavigationBar: BottomNavigationBar(
              onTap: (index) {
                _changeBottomNav(_, index);
              },
              backgroundColor: Colors.white,
              currentIndex: state,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              selectedItemColor: Colors.black,
              type: BottomNavigationBarType.fixed,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(
                    CupertinoIcons.home,
                    size: 25,
                  ),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.space_dashboard_outlined,
                    size: 25,
                  ),
                  label: 'Time',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    CupertinoIcons.list_bullet,
                    size: 25,
                  ),
                  label: 'List',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    CupertinoIcons.bell,
                    size: 25,
                  ),
                  label: 'Alert',
                ),
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.location, size: 25),
                  label: 'Campic',
                ),
              ],
            ),
            body: _buildBody(state),
          ),
        );
      },
    );
  }

  void _changeBottomNav(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.read<HomeCubit>().getMain();
        break;
      case 1:
        context.read<HomeCubit>().getTime();
        break;
      case 2:
        context.read<HomeCubit>().getList();
        break;
      case 3:
        context.read<HomeCubit>().getAlert();
        break;
      case 4:
        context.read<HomeCubit>().getCampic();
        break;
    }
  }

  Widget _buildBody(int index) {
    switch (index) {
      case 0:
        return googleMapPage();
      case 1:
        return googleMapPage();
      case 2:
        return freeForum();
      case 3:
        return googleMapPage();
      case 4:
        return googleMapPage();
      default:
        return googleMapPage();
    }
  }
}
