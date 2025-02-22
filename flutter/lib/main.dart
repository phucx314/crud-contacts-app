import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testapi_nashtech/model.dart';
import 'package:testapi_nashtech/viewmodel.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => Viewmodel()),
        ],
        child: const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: View(),
        ));
  }
}

class View extends StatelessWidget {
  const View({super.key});

  @override
  Widget build(BuildContext context) {
    final viewmodel = Provider.of<Viewmodel>(context);

    if (viewmodel.isLoading && viewmodel.contactsList.isEmpty) {
      viewmodel.getAllContacts();
    }
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white70,
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreatePage(),
            ),
          );
        },
      ),
      backgroundColor: Colors.black87,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => viewmodel.onRefreshAllContacts(context),
          child: Column(
            children: [
              AppBar(
                backgroundColor: Colors.black54,
                leading: const Icon(
                  Icons.menu,
                  color: Colors.white,
                ),
                centerTitle: true,
                title: const Text(
                  'Contacts',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: viewmodel
                      .scrollController, // gán scrollController vào ListView
                  itemCount: viewmodel.hasMore
                      ? viewmodel.contactsList.length + 1
                      : viewmodel.contactsList
                          .length, // Nếu không có thêm dữ liệu thì không thêm 1
                  itemBuilder: (context, index) {
                    if (index == viewmodel.contactsList.length) {
                      return viewmodel.hasMore
                          ? const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Center(child: CircularProgressIndicator()),
                            )
                          : const SizedBox.shrink();
                    }
                
                    final contact = viewmodel.contactsList[index];
                
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailedView(
                              id: contact.id!,
                              // id: viewmodel.contactsList[index].id!,
                            ),
                          ),
                        );
                        viewmodel.onRefreshContactDetails(context, contact.id!);
                      },
                      child: ListTile(
                        leading: ClipOval(
                          child: Image.network(
                            (viewmodel.contactsList[index].avatarUrl
                                        .isNotEmpty &&
                                    Uri.tryParse(viewmodel
                                                .contactsList[index].avatarUrl)
                                            ?.hasAbsolutePath ==
                                        true)
                                ? viewmodel.contactsList[index].avatarUrl
                                : 'https://sbcf.fr/wp-content/uploads/2018/03/sbcf-default-avatar.png',
                            height: 35,
                            width: 35,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                viewmodel.contactsList[index].name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                (viewmodel.contactsList[index].phoneNumber ==
                                        '')
                                    ? 'No phone number'
                                    : viewmodel.contactsList[index].phoneNumber,
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.white60,
                                ),
                              ),
                            ),
                          ],
                        ),
                        trailing: GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return Container(
                                  color: Colors.black87,
                                  child: Wrap(
                                    children: <Widget>[
                                        ListTile(
                                        leading: const Icon(Icons.edit, color: Colors.white),
                                        title: const Text('Edit', style: TextStyle(color: Colors.white)),
                                        onTap: () {
                                          Navigator.pop(context);
                                          viewmodel.fillContactFields(contact);
                                          Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) {
                                              // print(contact.id);
                                              return EditPage(id: contact.id!, modelContact: contact,);
                                            },
                                          ),
                                          );
                                        },
                                        ),
                                      ListTile(
                                        leading: const Icon(Icons.delete, color: Colors.white),
                                        title: const Text('Delete', style: TextStyle(color: Colors.white)),
                                        onTap: () {
                                          viewmodel.deleteContact(contact.id!);
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          child: Icon(
                            Icons.more_horiz,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DetailedView extends StatelessWidget {
  const DetailedView({super.key, required this.id});

  final int id;

  @override
  Widget build(BuildContext context) {
    final viewmodel = Provider.of<Viewmodel>(context);

    if (viewmodel.modelContact.id != id) {
      viewmodel.getContactById(id);
    }

    return Scaffold(
      backgroundColor: Colors.black87,
      body: SafeArea(
        child: Column(
          children: [
            AppBar(
              backgroundColor: Colors.black54,
              leading: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.chevron_left,
                  color: Colors.white,
                ),
              ),
              centerTitle: true,
              title: const Text(
                'Contact details',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              actions: const [
                Icon(
                  Icons.edit,
                  color: Colors.white,
                ),
              ],
            ),
            Column(
              children: [
                const SizedBox(
                  height: 25,
                ),
                GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                      content: Text(viewmodel.modelContact.avatarUrl),
                      ),
                    );
                  },
                  child: ClipOval(
                    child: Stack(
                      children: [
                        Container(
                          height: 165,
                          width: 165,
                          color: Colors.white10,
                          child: Padding(
                            padding: const EdgeInsets.all(7.0),
                            child: ClipOval(
                              child: Image.network(
                                (viewmodel.modelContact.avatarUrl.isNotEmpty &&
                                        Uri.tryParse(viewmodel
                                                    .modelContact.avatarUrl)
                                                ?.hasAbsolutePath ==
                                            true)
                                    ? viewmodel.modelContact.avatarUrl
                                    : 'https://sbcf.fr/wp-content/uploads/2018/03/sbcf-default-avatar.png',
                                fit: BoxFit.cover,
                                // errorBuilder: (context, error, stackTrace) {
                                //   return Image.asset(
                                //       'https://sbcf.fr/wp-content/uploads/2018/03/sbcf-default-avatar.png');
                                // },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  viewmodel.modelContact.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                const Divider(),
                const SizedBox(
                  height: 25,
                ),
                Text(
                  'Phone number: ${viewmodel.modelContact.phoneNumber}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const Divider(
                  color: Colors.white24,
                ),
                Text(
                  'Email: ${viewmodel.modelContact.email}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const Divider(
                  color: Colors.white24,
                ),
                Text(
                  'Home address: ${viewmodel.modelContact.homeAddress}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CreatePage extends StatelessWidget {
  const CreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    final viewmodel = Provider.of<Viewmodel>(context);

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.chevron_left,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        title: const Text(
          'Create Contact',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black54,
      ),
      backgroundColor: Colors.black87,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: viewmodel.nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: viewmodel.phoneNumberController,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: viewmodel.emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: viewmodel.homeAddressController,
              decoration: const InputDecoration(
                labelText: 'Home Address',
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: viewmodel.avatarUrlController,
              decoration: const InputDecoration(
                labelText: 'Avatar URL (Optional)',
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () async {
                int? newId = await viewmodel.addNewContact();
                // print('New contact ID: $newId');
                if (newId != null && context.mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailedView(id: newId),
                    ),
                  );
                  // viewmodel.onRefresh(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white70,
              ),
              child: const Text(
                'Create',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EditPage extends StatelessWidget {
  const EditPage({super.key, required this.id, required this.modelContact});

  final int id;
  final ModelContact modelContact;

  @override
  Widget build(BuildContext context) {
    final viewmodel = Provider.of<Viewmodel>(context);

    // Điền dữ liệu contact vào các TextEditingController
    viewmodel.fillContactFields(modelContact);

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.chevron_left,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        title: const Text(
          'Edit Contact',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black54,
      ),
      backgroundColor: Colors.black87,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: viewmodel.nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: viewmodel.phoneNumberController,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: viewmodel.emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: viewmodel.homeAddressController,
              decoration: const InputDecoration(
                labelText: 'Home Address',
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: viewmodel.avatarUrlController,
              decoration: const InputDecoration(
                labelText: 'Avatar URL (Optional)',
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () async {
                await viewmodel.updateContact(id);
                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white70,
              ),
              child: const Text(
                'Done',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}