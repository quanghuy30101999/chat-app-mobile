import 'package:flutter/material.dart';

class NewGroup extends StatefulWidget {
  const NewGroup({super.key});

  @override
  State<NewGroup> createState() => _NewGroupState();
}

class _NewGroupState extends State<NewGroup> {
  List<bool> isSelectedList = List.filled(20, false);
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return SizedBox(
      width: media.width,
      height: media.height * 0.9,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Huỷ',
                  style: TextStyle(color: Colors.blue[500], fontSize: 15),
                ),
                const Text(
                  'Nhóm mới',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w700),
                ),
                Text('Tạo',
                    style: TextStyle(color: Colors.blue[500], fontSize: 15))
              ],
            ),
            const TextField(
              decoration: InputDecoration(
                hintText: 'Tên nhóm (không bắt buộc)',
                hintStyle: TextStyle(
                    color: Colors.grey, fontWeight: FontWeight.normal),
                border: InputBorder.none, // Không có border
                filled: true,
                fillColor: Colors.transparent, // Màu nền trong suốt
              ),
              cursorHeight: 15,
            ),
            SizedBox(
              height: 40,
              child: TextField(
                cursorHeight: 20,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[200], // Màu xám
                  hintText: 'Tìm kiếm',
                  hintStyle: const TextStyle(color: Colors.grey),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 10.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 20,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        isSelectedList[index] = !isSelectedList[index];
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 80,
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(
                                'https://i.pinimg.com/736x/40/0e/b8/400eb8a3081a741b593f12591ac40036.jpg',
                              ),
                              radius: 25,
                            ),
                          ),
                          const SizedBox(width: 15),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 30),
                                SizedBox(
                                  height: 49,
                                  child: Text(
                                    'Trần Phương Vy',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                Divider(
                                  height: 1,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isSelectedList[index]
                                        ? Colors.blue
                                        : Colors.grey,
                                    width: 2,
                                  ),
                                  color: isSelectedList[index]
                                      ? Colors.blue
                                      : Colors.transparent,
                                ),
                                child: isSelectedList[index]
                                    ? const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 16,
                                      )
                                    : null,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
