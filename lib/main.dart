import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_pagination_test/api.dart';

const int maxPage = 5;

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends ConsumerWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pagination With Riverpod'),
        elevation: 0,
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              ref.read(pageProvider.state).state = 1;
              ref.read(itemList).clear();
              ref.refresh(getItemProvider);
            },
            child: const Text('Reload'),
          ),
          Expanded(
            child: ListView(
              children: [
                Consumer(
                  builder: (context, ref, child) {
                    return ref.watch(getItemProvider).when(
                          data: (data) {
                            if (ref.read(pageProvider) < maxPage &&
                                ref.read(pageProvider) !=
                                    1 /*not to call api page 1 two times */) {
                              ref.refresh(getItemProvider);
                            }

                            return SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: ref.watch(itemList).length,
                                    itemBuilder: (_, index) => Text(
                                      '${index + 1} :  ${ref.watch(itemList)[index].sId![(ref.watch(itemList)[index].sId)!.length - 1]}',
                                    ),
                                  ),
                                  ref.watch(getItemProvider).isLoading
                                      ? const Center(
                                          child: CircularProgressIndicator())
                                      : const SizedBox.shrink(),
                                ],
                              ),
                            );
                          },
                          error: (e, st) => Text('$e'),
                          loading: () => const Align(
                            alignment: Alignment.centerLeft,
                            child: CircularProgressIndicator(),
                          ),
                        );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
