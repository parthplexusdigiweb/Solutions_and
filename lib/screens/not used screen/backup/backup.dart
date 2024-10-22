class backup {



  void ViewChallengesDialog(documentReference,Id, Name, description, newvalues, keywords, createdat,createdby,tags, modifiedBy,modifiedDate,insideId,documents,i) {


    DateTime dateTime = createdat.toDate();


    final DateFormat formatter = DateFormat("MMMM d, yyyy 'at' h:mm:ss a 'UTC'Z");


    String formattedDate = formatter.format(dateTime);

    print("ViewChallengesDialog: $insideId");
    print("ViewChallengesDialog: ${insideId.runtimeType}");


    List<TextEditingController> textControllers = [];
    for(int i=0;i<6;i++){
      textControllers.add(TextEditingController());
    }
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Theme(
            data: Theme.of(context).copyWith(dialogBackgroundColor: Colors.white),
            child: AlertDialog(
                insetPadding: EdgeInsets.symmetric(horizontal: MediaQuery
                    .of(context)
                    .size
                    .width * 0.08, vertical: MediaQuery
                    .of(context)
                    .size
                    .height * 0.04),
                icon: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.close)),
                  ],
                ),
                iconPadding: EdgeInsets.only(top: 8, right: 16),
                content:   SizedBox(
                    width: double.maxFinite,
                    child: Consumer<
                        UserAboutMEProvider>(
                        builder: (c, userAboutMEProvider, _) {

                          var name = userAboutMEProvider.previewname==null ? Name : userAboutMEProvider.previewname;
                          var Description = userAboutMEProvider.previewDescription==null ? description : userAboutMEProvider.previewDescription;
                          // var OriginalDescription = doc?.get('Original Description');
                          var FinalDescription = userAboutMEProvider.previewFinalDescription==null ? documents['Final_description'] : userAboutMEProvider.previewFinalDescription;
                          var Impact = userAboutMEProvider.previewImpact==null ? documents['Impact'] : userAboutMEProvider.previewImpact;

                          // var Category = doc?.get("Category");
                          // var Source = (doc?.get("Source") == "" ||doc?.get("Source") == null )?"MTH RfA email 20240130":doc?.get("Source");
                          // var Status = (doc?.get("Challenge Status") == "" ||doc?.get("Challenge Status") == null ) ? 'New' : doc?.get("Challenge Status");

                          editKeywordssss =userAboutMEProvider.previewKeywordssss.isEmpty ? keywords : userAboutMEProvider.previewKeywordssss;
                          edittags = userAboutMEProvider.previewtags.isEmpty ? tags : userAboutMEProvider.previewtags;

                          _challengesProvider.addkeywordsList(editKeywordssss);
                          _challengesProvider.addProviderEditTagsList(edittags);

                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  // height: 400,
                                  padding: EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(20)
                                  ),
                                  child: SingleChildScrollView(
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          // (Source==""|| Source==null) ? Container() :  Row(
                                          //   mainAxisAlignment: MainAxisAlignment.start,
                                          //   crossAxisAlignment: CrossAxisAlignment.start,
                                          //   children: [
                                          //     Text("Source: ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),),
                                          //     Text(Source, style: TextStyle(fontSize: 20,),),
                                          //
                                          //   ],
                                          // ),
                                          // SizedBox(height: 10,),
                                          // (Status==""|| Status==null) ? Container() :  Row(
                                          //   mainAxisAlignment: MainAxisAlignment.start,
                                          //   crossAxisAlignment: CrossAxisAlignment.start,
                                          //   children: [
                                          //     Text("Challenge Status: ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),),
                                          //     Text(Status, style: TextStyle(fontSize: 20, ),),
                                          //
                                          //   ],
                                          // ),
                                          // SizedBox(height: 10,),
                                          (name==""|| name==null) ? Container() : Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              // Text("Label: ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),),
                                              Text(name,
                                                  style: GoogleFonts.montserrat(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 20,
                                                      color: Colors.black)),
                                              // IconButton(onPressed: (){
                                              //   Navigator.pop(context);
                                              // },
                                              //     icon:Icon(Icons.close)
                                              // ),
                                              Consumer<UserAboutMEProvider>(
                                                  builder: (c,userAboutMEProvider, _){
                                                    return
                                                      (userAboutMEProvider.isRecommendedChallengeCheckedMap[insideId] == true) ? Text(
                                                        'Added',
                                                        style: GoogleFonts.montserrat(
                                                          textStyle:
                                                          Theme
                                                              .of(context)
                                                              .textTheme
                                                              .titleSmall,
                                                          fontStyle: FontStyle.italic,
                                                          color:Colors.green ,
                                                        ),
                                                      ) : InkWell(
                                                        onTap: (){
                                                          userAboutMEProvider.isRecommendedAddedChallenge(true, documents);
                                                          toastification.show(context: context,
                                                              title: Text('${name} added successfully'),
                                                              autoCloseDuration: Duration(milliseconds: 2500),
                                                              alignment: Alignment.center,
                                                              backgroundColor: Colors.green,
                                                              foregroundColor: Colors.white,
                                                              icon: Icon(Icons.check_circle, color: Colors.white,),
                                                              animationDuration: Duration(milliseconds: 1000),
                                                              showProgressBar: false
                                                          );
                                                        },
                                                        child: Container(
                                                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                                                          width: MediaQuery.of(context).size.width * .05,
                                                          // width: MediaQuery.of(context).size.width * .15,

                                                          // height: 60,
                                                          decoration: BoxDecoration(
                                                            color:Colors.blue ,
                                                            border: Border.all(
                                                                color:Colors.blue ,
                                                                width: 1.0),
                                                            borderRadius: BorderRadius.circular(8.0),
                                                          ),
                                                          child: Center(
                                                            // child: Icon(Icons.add, size: 30,color: Colors.white,),
                                                            child: Text(
                                                              'Add',
                                                              style: GoogleFonts.montserrat(
                                                                textStyle:
                                                                Theme
                                                                    .of(context)
                                                                    .textTheme
                                                                    .titleSmall,
                                                                fontWeight: FontWeight.bold,
                                                                color:Colors.white ,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                  })
                                              ,
                                            ],
                                          ),
                                          SizedBox(height: 5,),
                                          (FinalDescription==""|| FinalDescription==null) ? Container() :  Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              // Text("Description: ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),),
                                              Flexible(child: Text(FinalDescription,  style: GoogleFonts.montserrat(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 20,
                                                  color: Colors.black),
                                                maxLines: null,)),
                                            ],
                                          ),
                                          SizedBox(height: 10,),

                                          (Impact==""|| Impact==null) ? Container() :  Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              // Text("Impact: ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),),
                                              Flexible(child: Text(Impact,  style: GoogleFonts.montserrat(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 20,
                                                  fontStyle: FontStyle.italic,
                                                  color: Colors.grey),
                                                maxLines: null,)),
                                            ],
                                          ),

                                          SizedBox(height: 10,),

                                          (Description==""|| Description==null) ? Container() :  Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              // Text("Description: ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),),
                                              Flexible(child: Text(Description,  style: GoogleFonts.montserrat(
                                                // fontWeight: FontWeight.w600,
                                                  fontSize: 16,
                                                  color: Colors.black),
                                                maxLines: null,)),
                                            ],
                                          ),

                                          SizedBox(height: 10,),




                                          (_challengesProvider.keywords==""|| _challengesProvider.keywords==null||_challengesProvider.keywords.isEmpty) ? Container() :
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              // Text("Category: ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),),
                                              Flexible(
                                                child: Consumer<ChallengesProvider>(
                                                    builder: (c,addKeywordProvider, _){
                                                      return Align(
                                                        alignment: Alignment.centerLeft,
                                                        child: Wrap(
                                                          spacing: 10,
                                                          runSpacing: 10,
                                                          crossAxisAlignment: WrapCrossAlignment.start,
                                                          alignment: WrapAlignment.start,
                                                          runAlignment: WrapAlignment.start,
                                                          children: addKeywordProvider.keywords.map((item){
                                                            print("item: $item");
                                                            print("addKeywordProvider.keywords: ${addKeywordProvider.keywords}");
                                                            return InkWell(
                                                              onTap: (){
                                                                searchChallengescontroller.text = item;
                                                                _challengesProvider.loadDataForPageSearchFilter(item);
                                                                Navigator.pop(context);
                                                              },
                                                              child: Container(
                                                                height: 50,
                                                                // width: 200,
                                                                margin: EdgeInsets.only(bottom: 10),
                                                                padding: EdgeInsets.all(8),
                                                                decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.circular(15),
                                                                    color: Color(0xFF00ACC1)
                                                                ),
                                                                child: Row(
                                                                  mainAxisSize: MainAxisSize.min,
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  children: [
                                                                    Text(item, style: TextStyle(
                                                                        fontWeight: FontWeight.w700,
                                                                        color: Colors.white
                                                                    ),),
                                                                  ],
                                                                ),
                                                              ),
                                                            );
                                                          }).toList(),
                                                        ),
                                                      );
                                                    }),
                                              ),
                                            ],
                                          ),

                                          SizedBox(height: 10),

                                          (_challengesProvider.ProviderEditTags==""|| _challengesProvider.ProviderEditTags==null||_challengesProvider.ProviderEditTags.isEmpty) ? Container() :  Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              // Text("Tags: ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),),

                                              Flexible(
                                                child: Consumer<ChallengesProvider>(
                                                    builder: (c,addKeywordProvider, _){
                                                      return Align(
                                                        alignment: Alignment.centerLeft,
                                                        child: Wrap(
                                                          spacing: 10,
                                                          runSpacing: 10,
                                                          crossAxisAlignment: WrapCrossAlignment.start,
                                                          alignment: WrapAlignment.start,
                                                          runAlignment: WrapAlignment.start,
                                                          children: addKeywordProvider.ProviderEditTags.map((item){
                                                            return InkWell(
                                                              onTap: (){
                                                                searchChallengescontroller.text = item;
                                                                _challengesProvider.loadDataForPageSearchFilter(item);
                                                                Navigator.pop(context);
                                                              },
                                                              child: Container(
                                                                height: 50,
                                                                // width: 200,
                                                                padding: EdgeInsets.all(8),
                                                                decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.circular(15),
                                                                    color: Colors.teal
                                                                ),
                                                                child: Row(
                                                                  mainAxisSize: MainAxisSize.min,
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  children: [
                                                                    Text(item, style: TextStyle(
                                                                        fontWeight: FontWeight.w700,
                                                                        color: Colors.white
                                                                    ),),
                                                                  ],
                                                                ),
                                                              ),
                                                            );
                                                          }).toList(),
                                                        ),
                                                      );

                                                    }),
                                              ),
                                            ],
                                          ),

                                        ]
                                    ),
                                  ),
                                ),
                                SizedBox(height: 15,),
                                Container(
                                  // height: 400,
                                  padding: EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(20)
                                  ),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Container(
                                          height: 170 ,
                                          child: FutureBuilder(
                                            future: getRelatedSolutions(tags, keywords),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState == ConnectionState.waiting) {
                                                return Container(
                                                    width: MediaQuery.of(context).size.width,
                                                    child: Container(
                                                        height: 20, // Adjust the height as needed
                                                        width: 20,
                                                        child: Center(
                                                            child: CircularProgressIndicator()
                                                        )
                                                    )
                                                ); // Display a loading indicator while fetching data
                                              } else if (snapshot.hasError) {
                                                return Text('Error: ${snapshot.error}');
                                              } else {
                                                // List<DocumentSnapshot<Object?>>? relatedSolutions = snapshot.data;
                                                List<DocumentSnapshot<Map<String, dynamic>>>? relatedSolutions = snapshot.data?.cast<DocumentSnapshot<Map<String, dynamic>>>();

                                                // print("relatedSolutions: $relatedSolutions");

                                                return Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
                                                      child: Text("Related Solutions (${relatedSolutions?.length})",
                                                          style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,
                                                              fontSize: 20,
                                                              color: Colors.black)
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: ListView.builder(
                                                        scrollDirection: Axis.horizontal,
                                                        shrinkWrap: true,
                                                        itemCount: relatedSolutions?.length,
                                                        itemBuilder: (c, i) {
                                                          // relatedSolutionlength = relatedSolutions?.length;
                                                          // print("relatedSolutionlength: $relatedSolutionlength");
                                                          var solutionData = relatedSolutions?[i].data() as Map<String, dynamic>;
                                                          print("solutionData: ${solutionData}");
                                                          return Container(
                                                            margin: EdgeInsets.symmetric(horizontal: 15),
                                                            padding: EdgeInsets.all(12),
                                                            width: 330,
                                                            decoration: BoxDecoration(
                                                              border: Border.all(color: Colors.black),
                                                              borderRadius: BorderRadius.circular(20),
                                                            ),
                                                            child: SingleChildScrollView(
                                                              child: Column(
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      Flexible(
                                                                        child: Text("${solutionData['Name']}",
                                                                            maxLines: null,
                                                                            style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,
                                                                                fontSize: 18,
                                                                                color: Colors.black)),
                                                                      ),
                                                                      SizedBox(width: 5,),
                                                                      // InkWell(
                                                                      //   onTap: (){
                                                                      //     _userAboutMEProvider.isRecommendedAddedSolutions(true, relatedSolutions![i]);
                                                                      //   },
                                                                      //   child: Container(
                                                                      //     padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                                                                      //     width: MediaQuery.of(context).size.width * .05,
                                                                      //     // width: MediaQuery.of(context).size.width * .15,
                                                                      //
                                                                      //     // height: 60,
                                                                      //     decoration: BoxDecoration(
                                                                      //       color: Colors.blue ,
                                                                      //       border: Border.all(
                                                                      //           color:Colors.blue ,
                                                                      //           width: 1.0),
                                                                      //       borderRadius: BorderRadius.circular(8.0),
                                                                      //     ),
                                                                      //     child: Center(
                                                                      //       // child: Icon(Icons.add, size: 30,color: Colors.white,),
                                                                      //       child: Text(
                                                                      //         'Add',
                                                                      //         style: GoogleFonts.montserrat(
                                                                      //           textStyle:
                                                                      //           Theme
                                                                      //               .of(context)
                                                                      //               .textTheme
                                                                      //               .titleSmall,
                                                                      //           fontWeight: FontWeight.bold,
                                                                      //           color:Colors.white ,
                                                                      //         ),
                                                                      //       ),
                                                                      //     ),
                                                                      //   ),
                                                                      // ),
                                                                      Consumer<UserAboutMEProvider>(
                                                                          builder: (c,userAboutMEProvider, _){
                                                                            return
                                                                              (userAboutMEProvider.isRecommendedSolutionsCheckedMap[solutionData['id']] == true) ? Text(
                                                                                'Added',
                                                                                style: GoogleFonts.montserrat(
                                                                                  textStyle:
                                                                                  Theme
                                                                                      .of(context)
                                                                                      .textTheme
                                                                                      .titleSmall,
                                                                                  fontStyle: FontStyle.italic,
                                                                                  color:Colors.green ,
                                                                                ),
                                                                              ) : InkWell(
                                                                                onTap: (){
                                                                                  // userAboutMEProvider.isRecommendedAddedChallenge(true, documents);
                                                                                  userAboutMEProvider.isRecommendedAddedSolutions(true, relatedSolutions![i]);
                                                                                  toastification.show(context: context,
                                                                                      title: Text('${solutionData['Name']} added successfully'),
                                                                                      autoCloseDuration: Duration(milliseconds: 2500),
                                                                                      alignment: Alignment.center,
                                                                                      backgroundColor: Colors.green,
                                                                                      foregroundColor: Colors.white,
                                                                                      icon: Icon(Icons.check_circle, color: Colors.white,),
                                                                                      animationDuration: Duration(milliseconds: 1000),
                                                                                      showProgressBar: false
                                                                                  );

                                                                                },
                                                                                child: Container(
                                                                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                                                                                  width: MediaQuery.of(context).size.width * .05,
                                                                                  // width: MediaQuery.of(context).size.width * .15,

                                                                                  // height: 60,
                                                                                  decoration: BoxDecoration(
                                                                                    color:Colors.blue ,
                                                                                    border: Border.all(
                                                                                        color:Colors.blue ,
                                                                                        width: 1.0),
                                                                                    borderRadius: BorderRadius.circular(8.0),
                                                                                  ),
                                                                                  child: Center(
                                                                                    // child: Icon(Icons.add, size: 30,color: Colors.white,),
                                                                                    child: Text(
                                                                                      'Add',
                                                                                      style: GoogleFonts.montserrat(
                                                                                        textStyle:
                                                                                        Theme
                                                                                            .of(context)
                                                                                            .textTheme
                                                                                            .titleSmall,
                                                                                        fontWeight: FontWeight.bold,
                                                                                        color:Colors.white ,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              );
                                                                          })
                                                                    ],
                                                                  ),
                                                                  SizedBox(height: 5,),
                                                                  // Icon(Icons.add, color: Colors.blue, size: 24,),
                                                                  Text("${solutionData['Final_description']}",
                                                                      maxLines: 3,
                                                                      style: GoogleFonts.montserrat(
                                                                          fontSize: 15,
                                                                          color: Colors.black)),
                                                                ],
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              }
                                            },
                                          ),
                                        ),

                                        SizedBox(height: 20,),
                                        Container(
                                          height: 170 ,
                                          child: FutureBuilder(
                                            future: getRelatedChallenges(tags, keywords),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState == ConnectionState.waiting) {
                                                return Container(
                                                    width: MediaQuery.of(context).size.width,
                                                    child: Container(
                                                        height: 20, // Adjust the height as needed
                                                        width: 20,
                                                        child: Center(
                                                            child: CircularProgressIndicator()
                                                        )
                                                    )
                                                ); // Display a loading indicator while fetching data
                                              } else if (snapshot.hasError) {
                                                return Text('Error: ${snapshot.error}');
                                              } else {
                                                // List<DocumentSnapshot<Object?>>? relatedSolutions = snapshot.data;

                                                List<DocumentSnapshot<Map<String, dynamic>>>? relatedChallenges = snapshot.data?.cast<DocumentSnapshot<Map<String, dynamic>>>();

                                                // print("relatedSolutions: $relatedSolutions");

                                                return Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.symmetric(
                                                          horizontal: 15.0, vertical: 8),
                                                      child: Text("Related Challenges (${relatedChallenges?.length})",
                                                          style: GoogleFonts.montserrat(
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 20,
                                                              color: Colors.black)
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: ListView.builder(
                                                        scrollDirection: Axis.horizontal,
                                                        shrinkWrap: true,
                                                        itemCount: relatedChallenges?.length,
                                                        itemBuilder: (c, i) {
                                                          // relatedSolutionlength = relatedChallenges?.length;
                                                          // print("relatedSolutionlength: $relatedSolutionlength");
                                                          var challengesData = relatedChallenges?[i].data() as Map<String, dynamic>;
                                                          print(
                                                              "solutionData: ${challengesData}");
                                                          return InkWell(
                                                            onTap: (){
                                                              userAboutMEProvider.updateChallengePreview(
                                                                  challengesData['Label'],
                                                                  challengesData['Description'],
                                                                  challengesData['Final_description'],
                                                                  challengesData['Impact'],
                                                                  challengesData['Keywords'],
                                                                  challengesData['tags']);
                                                              // NewViewDialog(challengesData['Label'], challengesData['Description'], challengesData['Impact'],
                                                              //     challengesData['Final_description'], challengesData['Keywords'], challengesData['tags'],
                                                              //     challengesData['id'], challengesData, userAboutMEProvider.isRecommendedChallengeCheckedMap);
                                                            },
                                                            child: Container(
                                                              margin: EdgeInsets.symmetric(horizontal: 15),
                                                              padding: EdgeInsets.all(12),
                                                              width: 330,
                                                              decoration: BoxDecoration(
                                                                border: Border.all(
                                                                    color: Colors.black),
                                                                borderRadius: BorderRadius.circular(20),
                                                              ),
                                                              child: SingleChildScrollView(
                                                                child: Column(
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Flexible(
                                                                          child: Text(
                                                                              "${challengesData['Label']}",
                                                                              style: GoogleFonts.montserrat(
                                                                                  fontWeight: FontWeight.bold,
                                                                                  fontSize: 18,
                                                                                  color: Colors.black)),
                                                                        ),
                                                                        // InkWell(
                                                                        //   onTap: (){
                                                                        //     _userAboutMEProvider.isRecommendedAddedChallenge(true,  relatedChallenges![i]);
                                                                        //   },
                                                                        //   child: Container(
                                                                        //     padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                                                                        //     width: MediaQuery.of(context).size.width * .05,
                                                                        //     // width: MediaQuery.of(context).size.width * .15,
                                                                        //
                                                                        //     // height: 60,
                                                                        //     decoration: BoxDecoration(
                                                                        //       color:Colors.blue ,
                                                                        //       border: Border.all(
                                                                        //           color:Colors.blue ,
                                                                        //           width: 1.0),
                                                                        //       borderRadius: BorderRadius.circular(8.0),
                                                                        //     ),
                                                                        //     child: Center(
                                                                        //       // child: Icon(Icons.add, size: 30,color: Colors.white,),
                                                                        //       child: Text(
                                                                        //         'Add',
                                                                        //         style: GoogleFonts.montserrat(
                                                                        //           textStyle:
                                                                        //           Theme
                                                                        //               .of(context)
                                                                        //               .textTheme
                                                                        //               .titleSmall,
                                                                        //           fontWeight: FontWeight.bold,
                                                                        //           color:Colors.white ,
                                                                        //         ),
                                                                        //       ),
                                                                        //     ),
                                                                        //   ),
                                                                        // ),

                                                                        (userAboutMEProvider.isRecommendedChallengeCheckedMap[challengesData['id']] == true)
                                                                            ? Text('Added',
                                                                          style: GoogleFonts.montserrat(
                                                                            textStyle: Theme.of(context).textTheme.titleSmall,
                                                                            fontStyle: FontStyle.italic,
                                                                            color: Colors.green,
                                                                          ),
                                                                        )
                                                                            : InkWell(
                                                                          onTap: () {
                                                                            // userAboutMEProvider.isRecommendedAddedChallenge(true, documents);
                                                                            userAboutMEProvider.isRecommendedAddedChallenge(true, relatedChallenges![i]);
                                                                            toastification.show(
                                                                                context: context,
                                                                                title: Text('${challengesData['Label']} added successfully'),
                                                                                autoCloseDuration: Duration(milliseconds: 2500),
                                                                                alignment: Alignment.center,
                                                                                backgroundColor: Colors.green,
                                                                                foregroundColor: Colors.white,
                                                                                icon: Icon(Icons.check_circle,
                                                                                  color: Colors.white,),
                                                                                animationDuration: Duration(milliseconds: 1000),
                                                                                showProgressBar: false
                                                                            );
                                                                          },
                                                                          child: Container(
                                                                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                                                                            width: MediaQuery.of(context).size.width * .05,
                                                                            // width: MediaQuery.of(context).size.width * .15,

                                                                            // height: 60,
                                                                            decoration: BoxDecoration(
                                                                              color: Colors.blue,
                                                                              border: Border.all(
                                                                                  color: Colors.blue,
                                                                                  width: 1.0),
                                                                              borderRadius: BorderRadius.circular(8.0),
                                                                            ),
                                                                            child: Center(
                                                                              // child: Icon(Icons.add, size: 30,color: Colors.white,),
                                                                              child: Text('Add',
                                                                                style: GoogleFonts.montserrat(
                                                                                  textStyle:
                                                                                  Theme.of(
                                                                                      context).textTheme.titleSmall,
                                                                                  fontWeight: FontWeight.bold,
                                                                                  color: Colors.white,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      height: 5,),
                                                                    // Text("${challengesData['Label']}",
                                                                    //     style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,
                                                                    //         fontSize: 18,
                                                                    //         color: Colors.black)),
                                                                    Text("${challengesData['Final_description']}",
                                                                        maxLines: 3,
                                                                        style: GoogleFonts.montserrat(
                                                                            fontSize: 15,
                                                                            color: Colors.black)
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                );

                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                              ],
                            ),
                          );

                        })
                )
            ),
          );
          // });
        }
    );
  }


  Widget PreviewPage() {
    return Consumer<PreviewProvider>(
        builder: (c,previewProvider, _){
          return  Container(
            height: MediaQuery
                .of(context)
                .size
                .height,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 5,),
                  // SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 5),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text("Report : ", style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.titleMedium,fontStyle: FontStyle.italic)),

                        Flexible(
                          child: Container(
                            height: 40,
                            width: MediaQuery.of(context).size.width * .25,
                            child: TextField(
                              controller: AboutMeLabeltextController,
                              onChanged: (value) {
                                _previewProvider.updatetitle(value);
                              },
                              style: GoogleFonts.montserrat(
                                  textStyle: Theme.of(context).textTheme.bodySmall,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black),
                              decoration: InputDecoration(
                                hintText: "About Me Title",
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                    borderRadius: BorderRadius.circular(10)),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black12),
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(width: 10,),

                        InkWell(
                          onTap: () async {
                            // sideMenu.changePage(2);
                            // page.jumpToPage(1);
                          },
                          child: Container(
                            // margin: EdgeInsets.all(10),
                            padding: EdgeInsets.all(5),
                            height: 40,
                            width: MediaQuery.of(context).size.width * 0.15,
                            decoration: BoxDecoration(
                              // color: Colors.white,
                              border: Border.all(color:primaryColorOfApp, width: 1.0),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(Icons.insert_drive_file,color: Colors.black,size: 20,),
                                SizedBox(width: 5,),
                                Expanded(
                                  child: Text(
                                    // 'Thrivers',
                                    'For Someone Else',
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.montserrat(
                                        textStyle:
                                        Theme.of(context).textTheme.bodySmall,
                                        color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                          ),

                        ),

                      ],
                    ),
                  ),

                  Divider(color: Colors.black26,),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 5),
                    child: TextField(
                      controller: AboutMeDescriptiontextController,
                      onChanged: (value) {
                        // _previewProvider.updatetitle(value);
                      },
                      style: GoogleFonts.montserrat(
                          textStyle: Theme.of(context).textTheme.bodySmall,
                          fontWeight: FontWeight.w400,
                          color: Colors.black),
                      decoration: InputDecoration(
                        hintText: "Description",
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(10)),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black12),
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),

                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 5),
                          child: Text("Personal Info",
                              style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.black)),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("1. Email: ",
                                  style: GoogleFonts.montserrat(textStyle: Theme
                                      .of(context)
                                      .textTheme
                                      .titleMedium,)),
                              Text("${previewProvider.email==null ? "" : previewProvider.email}",
                                  style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.bodyLarge,fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("2. Name: ",
                                  style: GoogleFonts.montserrat(textStyle: Theme
                                      .of(context)
                                      .textTheme
                                      .titleMedium,)),
                              Text("${previewProvider.name==null ? "" : previewProvider.name}",
                                  style: GoogleFonts.montserrat(textStyle: Theme
                                      .of(context)
                                      .textTheme
                                      .bodyLarge,fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("3. Employer: ",
                                  style: GoogleFonts.montserrat(textStyle: Theme
                                      .of(context)
                                      .textTheme
                                      .titleMedium,)),
                              Text("${previewProvider.employer==null ? "" : previewProvider.employer}",
                                  style: GoogleFonts.montserrat(textStyle: Theme
                                      .of(context)
                                      .textTheme
                                      .bodyLarge,fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("4. Division or section: ",
                                  style: GoogleFonts.montserrat(textStyle: Theme
                                      .of(context)
                                      .textTheme
                                      .titleMedium,)),
                              Text("${previewProvider.division==null ? "" : previewProvider.division}",
                                  style: GoogleFonts.montserrat(textStyle: Theme
                                      .of(context)
                                      .textTheme
                                      .bodyLarge,fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,

                            children: [
                              Text("5. Role: ",
                                  style: GoogleFonts.montserrat(textStyle: Theme
                                      .of(context)
                                      .textTheme
                                      .titleMedium,)),
                              Text("${previewProvider.role==null ? "" : previewProvider.role}",
                                  style: GoogleFonts.montserrat(textStyle: Theme
                                      .of(context)
                                      .textTheme
                                      .bodyLarge,fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,

                            children: [
                              Text("6. Location: ",
                                  style: GoogleFonts.montserrat(textStyle: Theme
                                      .of(context)
                                      .textTheme
                                      .titleMedium,)),
                              Text("${previewProvider.location==null ? "" : previewProvider.location}",
                                  style: GoogleFonts.montserrat(textStyle: Theme
                                      .of(context)
                                      .textTheme
                                      .bodyLarge,fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("7. Employee number: ",
                                  style: GoogleFonts.montserrat(textStyle: Theme
                                      .of(context)
                                      .textTheme
                                      .titleMedium,)),
                              Text("${previewProvider.employeeNumber==null ? "" : previewProvider.employeeNumber}",
                                  style: GoogleFonts.montserrat(textStyle: Theme
                                      .of(context)
                                      .textTheme
                                      .bodyLarge,fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("8. Line manager:",
                                  style: GoogleFonts.montserrat(textStyle: Theme
                                      .of(context)
                                      .textTheme
                                      .titleMedium,)),
                              Text("${previewProvider.linemanager==null ? "" : previewProvider.linemanager}",
                                  style: GoogleFonts.montserrat(textStyle: Theme
                                      .of(context)
                                      .textTheme
                                      .bodyLarge,fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 5),
                          child: Text("Insight about me",
                              style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.black)),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 5),
                          child: Text("1. About Me and My circumstances: ",
                              style: GoogleFonts.montserrat(textStyle: Theme
                                  .of(context)
                                  .textTheme
                                  .titleMedium,)),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5),
                          child: Text("${previewProvider.mycircumstance==null ? "" : previewProvider.mycircumstance}",
                              style: GoogleFonts.montserrat(textStyle: Theme
                                  .of(context)
                                  .textTheme
                                  .bodyLarge,fontWeight: FontWeight.w700)),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 5),
                          child: Text("2. My strengths that I want to have the opportunity to use in my role: ",
                              style: GoogleFonts.montserrat(textStyle: Theme
                                  .of(context)
                                  .textTheme
                                  .titleMedium,)),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5),
                          child: Text("${previewProvider.mystrength==null ? "" : previewProvider.mystrength}",
                              style: GoogleFonts.montserrat(textStyle: Theme
                                  .of(context)
                                  .textTheme
                                  .bodyLarge,fontWeight: FontWeight.w700)),

                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 5),
                          child: Text("3. What I value about [my organisation] and workplace environment that helps me perform to my best: ",
                              style: GoogleFonts.montserrat(textStyle: Theme
                                  .of(context)
                                  .textTheme
                                  .titleMedium,)),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5),
                          child: Text("${previewProvider.myorganization==null ? "" : previewProvider.myorganization}",
                              style: GoogleFonts.montserrat(textStyle: Theme
                                  .of(context)
                                  .textTheme
                                  .bodyLarge,fontWeight: FontWeight.w700)),

                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 5),
                          child: Text("4. What I find challenging about [My Organisation] and the workplace environment that makes it harder for me to perform my best: ",
                              style: GoogleFonts.montserrat(textStyle: Theme
                                  .of(context)
                                  .textTheme
                                  .titleMedium,)),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5),
                          child: Text("${previewProvider.mychallenge==null ? "" : previewProvider.mychallenge}",
                              style: GoogleFonts.montserrat(textStyle: Theme
                                  .of(context)
                                  .textTheme
                                  .bodyLarge,fontWeight: FontWeight.w700)),

                        ),
                      ],
                    ),
                  ),

                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 5),
                          child: Text("Challenges",
                              style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.black)),
                        ),
                        Consumer<PreviewProvider>(
                          builder: (context, previewProvider, _) {
                            // solutions = userAboutMEProvider.getSelectedSolutions();
                            print("PreviewChallengesList : ${previewProvider.PreviewChallengesList}");


                            return Container(
                              // height: MediaQuery.of(context).size.height * .6,
                              width: MediaQuery.of(context).size.width ,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black26),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              // width: MediaQuery.of(context).size.width,
                              child:SingleChildScrollView(
                                child: DataTable(
                                  dataRowMaxHeight:60 ,
                                  headingTextStyle: GoogleFonts.montserrat(
                                      textStyle: Theme.of(context).textTheme.titleMedium,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black),
                                  columnSpacing: 15,
                                  columns: [
                                    DataColumn(
                                      label: Container(
                                        // color: Colors.blue,
                                        // width: 60,
                                        child: Text('Id',textAlign: TextAlign.center,),
                                      ),

                                    ),
                                    DataColumn(
                                      label: Container(
                                        // width: 180,
                                        child: Text('Label',),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text('Impact',),
                                    ),
                                    DataColumn(
                                      label: Container(
                                        // width: 400,
                                          child: Text('Description')
                                      ),
                                    ),
                                    DataColumn(
                                      label: Container(
                                        // width: 400,
                                          child: Text('Impact on me')
                                      ),
                                    ),
                                    DataColumn(
                                      label: Container(
                                        // width: 400,
                                          child: Text('Attachment')
                                      ),
                                    ),


                                  ],

                                  rows: previewProvider.PreviewChallengesList.map((solution) {
                                    int index = previewProvider.PreviewChallengesList.indexOf(solution);


                                    // print(jsonString);

                                    id = solution['id'];
                                    Label = solution['Label'];
                                    Impact = solution['Impact'];
                                    Final_description = solution['Final_description'];
                                    Impact_on_me = solution['Impact_on_me'];
                                    Attachment = solution['Attachment'];

                                    return DataRow(
                                      cells: [
                                        DataCell(
                                            Container(
                                              // width: 60,
                                                child: Text("CH0${solution['id']}.", style: GoogleFonts.montserrat(
                                                  // child: Text("${index + 1}.", style: GoogleFonts.montserrat(
                                                    textStyle: Theme.of(context).textTheme.bodySmall,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black),))),
                                        DataCell(
                                            Container(
                                              // width: 180,
                                                child: Text(solution['Label'],
                                                    overflow: TextOverflow.ellipsis,maxLines: 2,
                                                    style: GoogleFonts.montserrat(
                                                        textStyle: Theme.of(context).textTheme.bodySmall,
                                                        fontWeight: FontWeight.w600,
                                                        color: Colors.black)
                                                ))),
                                        DataCell(
                                            Container(
                                              // width: 400,
                                                child: Text(solution['Impact'],
                                                    overflow: TextOverflow.ellipsis,maxLines: 2,
                                                    style: GoogleFonts.montserrat(
                                                        textStyle: Theme.of(context).textTheme.bodySmall,
                                                        fontWeight: FontWeight.w600,
                                                        color: Colors.black)
                                                ))),
                                        DataCell(
                                            Container(
                                              // width: 400,
                                                child: Text(solution['Final_description'],
                                                    overflow: TextOverflow.ellipsis,maxLines: 2,
                                                    style: GoogleFonts.montserrat(
                                                        textStyle: Theme.of(context).textTheme.bodySmall,
                                                        fontWeight: FontWeight.w600,
                                                        color: Colors.black)
                                                ))),

                                        DataCell(
                                            Container(
                                              // width: 400,
                                                child: Text(solution['Impact_on_me'],
                                                    overflow: TextOverflow.ellipsis,maxLines: 2,
                                                    style: GoogleFonts.montserrat(
                                                        textStyle: Theme.of(context).textTheme.bodySmall,
                                                        fontWeight: FontWeight.w600,
                                                        color: Colors.black)
                                                ))),

                                        DataCell(
                                            Container(
                                              // width: 400,
                                                child: Text(solution['Attachment'],
                                                    overflow: TextOverflow.ellipsis,maxLines: 2,
                                                    style: GoogleFonts.montserrat(
                                                        textStyle: Theme.of(context).textTheme.bodySmall,
                                                        fontWeight: FontWeight.w600,
                                                        color: Colors.black)
                                                ))),

                                        // DataCell(
                                        //   Container(
                                        //     // height: 100,
                                        //     margin: EdgeInsets.all(5),
                                        //     width: 140,
                                        //     child: Center(
                                        //       child: TextField(
                                        //         maxLines: 4,
                                        //         controller: TextEditingController(text: solution.notes),
                                        //         onChanged: (value) {
                                        //         },
                                        //         style: GoogleFonts.montserrat(
                                        //             textStyle: Theme
                                        //                 .of(context)
                                        //                 .textTheme
                                        //                 .bodySmall,
                                        //             fontWeight: FontWeight.w400,
                                        //             color: Colors.black),
                                        //         decoration: InputDecoration(
                                        //           contentPadding: EdgeInsets.all(10),
                                        //           // labelText: "Name",
                                        //           hintText: "Notes",
                                        //           errorStyle: GoogleFonts.montserrat(
                                        //               textStyle: Theme
                                        //                   .of(context)
                                        //                   .textTheme
                                        //                   .bodyLarge,
                                        //               fontWeight: FontWeight.w400,
                                        //               color: Colors.redAccent),
                                        //           focusedBorder: OutlineInputBorder(
                                        //               borderSide: BorderSide(color: Colors.black),
                                        //               borderRadius: BorderRadius.circular(5)),
                                        //           border: OutlineInputBorder(
                                        //               borderSide: BorderSide(color: Colors.black12),
                                        //               borderRadius: BorderRadius.circular(5)),
                                        //           labelStyle: GoogleFonts.montserrat(
                                        //               textStyle: Theme
                                        //                   .of(context)
                                        //                   .textTheme
                                        //                   .bodyLarge,
                                        //               fontWeight: FontWeight.w400,
                                        //               color: Colors.black),
                                        //         ),
                                        //       ),
                                        //     ),
                                        //   ),), // Empty cell for Notes

                                        // DataCell(
                                        //     Container(
                                        //       child: IconButton(
                                        //         onPressed: (){
                                        //
                                        //         },
                                        //         icon: Icon(Icons.add),
                                        //       ),
                                        //     )),  // Empty cell for Attachments
                                        // DataCell(
                                        //   Container(
                                        //     width: 120,
                                        //     child: DropdownButton(
                                        //       style: TextStyle(fontSize: 12,overflow: TextOverflow.ellipsis),
                                        //       // value: selectedProvider,
                                        //       value: selectedProviderValues[index],
                                        //       onChanged: (newValue) {
                                        //         // userAboutMEProvider.updatevalue(selectedProviderValues[index], newValue.toString());
                                        //         setState(() {
                                        //           // selectedProvider = newValue.toString();
                                        //           selectedProviderValues[index] = newValue.toString();
                                        //         });
                                        //       },
                                        //       items: provider.map((option) {
                                        //         return DropdownMenuItem(
                                        //           value: option,
                                        //           child: Text(option, overflow: TextOverflow.ellipsis,maxLines: 2,),
                                        //         );
                                        //       }).toList(),
                                        //     ),
                                        //   ),
                                        // ),  // Empty cell for Provider
                                        // DataCell(
                                        //   Container(
                                        //     width: 60,
                                        //     child: DropdownButton(
                                        //       style: TextStyle(fontSize: 12,overflow: TextOverflow.ellipsis),
                                        //       value: selectedInPlaceValues[index],
                                        //       // value: selectedInPlace,
                                        //       onChanged: (newValue) {
                                        //         setState(() {
                                        //           selectedInPlaceValues[index] = newValue.toString();
                                        //           // selectedInPlace = newValue.toString();
                                        //         });
                                        //       },
                                        //       items: InPlace.map((option) {
                                        //         return DropdownMenuItem(
                                        //           value: option,
                                        //           child: Text(option),
                                        //         );
                                        //       }).toList(),
                                        //     ),
                                        //   ),
                                        // ),  // Empty cell for In Place
                                        // DataCell(
                                        //   Container(
                                        //     width: 140,
                                        //     // child:  DropdownButton(
                                        //     //   style: TextStyle(fontSize: 12,overflow: TextOverflow.ellipsis),
                                        //     //   value: selectedPriorityValues[index],
                                        //     //   // value: selectedPriority,
                                        //     //   onChanged: (newValue) {
                                        //     //     setState(() {
                                        //     //       selectedPriorityValues[index] = newValue.toString();
                                        //     //
                                        //     //       print("$index: ${selectedPriorityValues[index]} ");
                                        //     //       // selectedPriority = newValue.toString();
                                        //     //     });
                                        //     //   },
                                        //     //   items: Priority.map((option) {
                                        //     //     return DropdownMenuItem(
                                        //     //       value: option,
                                        //     //       child: Text(option, overflow: TextOverflow.ellipsis,),
                                        //     //     );
                                        //     //   }).toList(),
                                        //     // ),
                                        //     child:  DropdownButtonFormField(
                                        //       style: TextStyle(fontSize: 12,overflow: TextOverflow.ellipsis),
                                        //       decoration: InputDecoration(
                                        //
                                        //         hintText: 'Priority',
                                        //       ),
                                        //       value: userAboutMEProvider.selectedPriorityValues[index],
                                        //       onChanged: (newValue) {
                                        //         userAboutMEProvider.updateSelectedPriorityValues(index, newValue);
                                        //         print('priority ${index} and ${userAboutMEProvider.selectedPriorityValues}');
                                        //       },
                                        //       icon: Icon(Icons.keyboard_arrow_down_outlined,size: 20,),
                                        //       items: selectedPriorityValues.map<DropdownMenuItem<String>>((String value) {
                                        //         // String displayedText = value;
                                        //         // if (displayedText.length > 5) {
                                        //         //   // Limit the displayed text to 10 characters and add ellipsis
                                        //         //   displayedText = displayedText.substring(0, 5) + '..';
                                        //         // }
                                        //         return DropdownMenuItem<String>(
                                        //           value: value,
                                        //           child: Text(value, overflow: TextOverflow.ellipsis,),
                                        //         );
                                        //       }).toList(),
                                        //     ),
                                        //   ),
                                        // ),  // Empty cell for Priority

                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),

                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 5),
                          child: Text("Solutions",
                              style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.black)),
                        ),
                        Consumer<PreviewProvider>(
                          builder: (context, previewProvider, _) {
                            print("PreviewSolutionList : ${previewProvider.PreviewSolutionList}");


                            return Container(
                              // height: 350,
                              // height: MediaQuery.of(context).size.height * .48,
                              width: MediaQuery.of(context).size.width,

                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black26),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              // width: MediaQuery.of(context).size.width,
                              child:SingleChildScrollView(
                                child: DataTable(
                                  dataRowMaxHeight:60 ,
                                  headingTextStyle: GoogleFonts.montserrat(
                                      textStyle: Theme.of(context).textTheme.titleMedium,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black),
                                  // border: TableBorder.all(color: Colors.black),
                                  columnSpacing: 15,
                                  columns: [

                                    DataColumn(
                                      label: Container(
                                        // color: Colors.blue,
                                        // width: 60,
                                        child: Text('Id',textAlign: TextAlign.center,),
                                      ),

                                    ),
                                    DataColumn(
                                      label: Container(
                                        // width: 180,
                                        child: Text('label',),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Container(
                                        // width: 250,
                                        child: Text('Impact',),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Container(
                                        // width: 400,
                                          child: Text('Description')
                                      ),
                                    ),
                                    DataColumn(
                                      label: Container(
                                        // width: 400,
                                          child: Text('Provider')
                                      ),
                                    ),
                                    DataColumn(
                                      label: Flexible(
                                        // width: 400,
                                          child: Text('In Place')
                                      ),
                                    ),
                                    DataColumn(
                                      label: Container(
                                        // width: 400,
                                          child: Text('Attachment')
                                      ),
                                    ),
                                  ],
                                  rows: previewProvider.PreviewSolutionList.map((challenge) {
                                    int index = previewProvider.PreviewSolutionList.indexOf(challenge);
                                    // print(jsonString);
                                    return DataRow(
                                      cells: [
                                        DataCell(
                                            Container(
                                              // width: 60,
                                              //   child: Text("${index + 1}.", style: GoogleFonts.montserrat(
                                                child: Text("SH0${challenge['id']}.", style: GoogleFonts.montserrat(
                                                    textStyle: Theme.of(context).textTheme.bodySmall,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black),))
                                        ),
                                        DataCell(
                                            Container(
                                              child: Text(challenge['Label'],
                                                  overflow: TextOverflow.ellipsis,maxLines: 2,
                                                  style: GoogleFonts.montserrat(
                                                      textStyle: Theme.of(context).textTheme.bodySmall,
                                                      fontWeight: FontWeight.w600,
                                                      color: Colors.black)
                                              ),
                                            )),
                                        DataCell(
                                            Container(
                                              // width: 250,
                                                child: Text(challenge["Impact"],
                                                    overflow: TextOverflow.ellipsis,maxLines: 2,
                                                    style: GoogleFonts.montserrat(
                                                        textStyle: Theme.of(context).textTheme.bodySmall,
                                                        fontWeight: FontWeight.w600,
                                                        color: Colors.black)
                                                ))),
                                        DataCell(
                                            Container(
                                              // width: 400,
                                                child: Text(challenge['Final_description'],
                                                    overflow: TextOverflow.ellipsis,maxLines: 2,
                                                    style: GoogleFonts.montserrat(
                                                        textStyle: Theme.of(context).textTheme.bodySmall,
                                                        fontWeight: FontWeight.w600,
                                                        color: Colors.black)
                                                ))),
                                        DataCell(
                                            Container(
                                              // width: 400,
                                                child: Text(challenge['Provider']==null ? "" : challenge['Provider'],
                                                    overflow: TextOverflow.ellipsis,maxLines: 2,
                                                    style: GoogleFonts.montserrat(
                                                        textStyle: Theme.of(context).textTheme.bodySmall,
                                                        fontWeight: FontWeight.w600,
                                                        color: Colors.black)
                                                ))),
                                        DataCell(
                                            Container(
                                              // width: 400,
                                                child: Text(challenge['InPlace']==null ? "" : challenge['InPlace'],
                                                    overflow: TextOverflow.ellipsis,maxLines: 2,
                                                    style: GoogleFonts.montserrat(
                                                        textStyle: Theme.of(context).textTheme.bodySmall,
                                                        fontWeight: FontWeight.w600,
                                                        color: Colors.black)
                                                ))),
                                        DataCell(
                                            Container(
                                              // width: 400,
                                                child: Text(challenge['Attachment']==null ? "" : challenge['Attachment'],
                                                    overflow: TextOverflow.ellipsis,maxLines: 2,
                                                    style: GoogleFonts.montserrat(
                                                        textStyle: Theme.of(context).textTheme.bodySmall,
                                                        fontWeight: FontWeight.w600,
                                                        color: Colors.black)
                                                ))),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),

                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 5),
                    child: TextField(
                      controller: AboutMeUseFulInfotextController,
                      onChanged: (value) {
                        _previewProvider.updatetitle(value);
                      },
                      style: GoogleFonts.montserrat(
                          textStyle: Theme.of(context).textTheme.bodySmall,
                          fontWeight: FontWeight.w400,
                          color: Colors.black),
                      decoration: InputDecoration(
                        hintText: "Links/Document/Product Info",
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(10)),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black12),
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),

                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5),
                        child: Text("Attachments :", style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.titleSmall,)),
                      ),
                      SizedBox(width: 10,),

                      // InkWell(
                      //   onTap: (){
                      //     // _userAboutMEProvider.pickFiles();
                      //   },
                      //   child: Container(
                      //     // padding: EdgeInsets.all(20),
                      //     child: Center(child: Icon(Icons.add, size: 30, color: Colors.white,)),
                      //     width: 30,
                      //     height: 30,
                      //     decoration: BoxDecoration(
                      //       color: Colors.blue,
                      //       borderRadius: BorderRadius.circular(50),
                      //     ),
                      //   ),
                      // ),
                      IconButton(onPressed: (){},
                        icon: Container(
                          // padding: EdgeInsets.all(20),
                          child: Center(child: Icon(Icons.add, size: 30, color: Colors.white,)),
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        tooltip: "Medical and Personal",
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("${_userAboutMEProvider.aadhar==null ? "" : _userAboutMEProvider.aadhar}", style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.titleSmall,)),
                    // child: Text("document.pdf", style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.titleSmall,)),
                  ),
                  SizedBox(height: 10,),

                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [

                        // Text("5. Preview",
                        //     style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,
                        //         fontSize: 30,
                        //         color: Colors.black)),

                        InkWell(
                          onTap: () async {

                            var createdAt = DateFormat('yyyy-MM-dd, hh:mm').format(DateTime.now());

                            Map<String, dynamic> AboutMEDatas = {
                              'About_Me_Label': AboutMeLabeltextController.text,
                              'AB_Status' : "Complete",
                              'AB_Description' : AboutMeDescriptiontextController.text,
                              'AB_Useful_Info' : AboutMeUseFulInfotextController.text,
                              'AB_Attachment' : "",
                            };

                            String solutionJson = json.encode(AboutMEDatas);
                            print(solutionJson);

                            ProgressDialog.show(context, "Completing", Icons.save);
                            await ApiRepository().updateAboutMe(AboutMEDatas,documentId);

                            ProgressDialog.hide();

                            sendMailPopUp(challengesList,solutionsList);

                            // selectedEmail = null;
                            // nameController.clear();
                            // searchEmailcontroller.clear();
                            // employerController.clear();
                            // divisionOrSectionController.clear();
                            // RoleController.clear();
                            // LocationController.clear();
                            // EmployeeNumberController.clear();
                            // LineManagerController.clear();
                            // mycircumstancesController.clear();
                            // MystrengthsController.clear();
                            // mycircumstancesController.clear();
                            // AboutMeLabeltextController.clear();
                            // RefineController.clear();
                            // solutionsList.clear();
                            // _userAboutMEProvider.solutionss.clear();
                            // _userAboutMEProvider.challengess.clear();
                            // _userAboutMEProvider.combinedSolutionsResults.clear();
                            // _userAboutMEProvider.combinedResults.clear();
                            // previewProvider.email=null;
                            // previewProvider.name=null;
                            // previewProvider.employer=null;
                            // previewProvider.division=null;
                            // previewProvider.role=null;
                            // previewProvider.location=null;
                            // previewProvider.employeeNumber=null ;
                            // previewProvider.linemanager=null;
                            // previewProvider.title=null;
                            // previewProvider.mycircumstance=null;
                            // previewProvider.mystrength=null ;
                            // previewProvider.myorganization=null ;
                            // previewProvider.mychallenge=null ;
                            // previewProvider.PreviewChallengesList.clear();
                            // previewProvider.PreviewSolutionList.clear();
                            // // _navigateToTab(0);
                            // // Navigator.pop(context);
                            // setState(() {
                            //   page.jumpToPage(1);
                            // });
                          },
                          child:Container(
                            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                            width: MediaQuery.of(context).size.width * .15,
                            decoration: BoxDecoration(
                              color:Colors.blue ,
                              border: Border.all(
                                  color:Colors.blue ,
                                  width: 1.0),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Center(
                              child:Text(
                                'Complete and Send',
                                style: GoogleFonts.montserrat(
                                  textStyle:
                                  Theme
                                      .of(context)
                                      .textTheme
                                      .titleSmall,
                                  fontWeight: FontWeight.bold,
                                  color:Colors.white ,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )

                ],
              ),
            ),
          );
        });
  }


  Widget NEWPreviewPage() {
    return Consumer<PreviewProvider>(
        builder: (c,previewProvider, _){

          DateTime date = DateTime.now();
          final DateFormat formatter = DateFormat('dd MMMM yyyy');
          String formattedDate = formatter.format(date);

          AboutMeDescriptiontextController.text = message;

          return  Container(
            height: MediaQuery
                .of(context)
                .size
                .height,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 5,),
                  // SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 5),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text("Report : ", style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.titleMedium,fontStyle: FontStyle.italic)),

                        Flexible(
                          child: Container(
                            height: 40,
                            width: MediaQuery.of(context).size.width * .25,
                            child: TextField(
                              controller: AboutMeLabeltextController,
                              onChanged: (value) {
                                _previewProvider.updatetitle(value);
                              },
                              style: GoogleFonts.montserrat(
                                  textStyle: Theme.of(context).textTheme.bodySmall,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black),
                              decoration: InputDecoration(
                                hintText: "About Me Title",
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                    borderRadius: BorderRadius.circular(10)),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black12),
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(width: 10,),

                        InkWell(
                          onTap: () async {
                            // sideMenu.changePage(2);
                            // page.jumpToPage(1);
                          },
                          child: Container(
                            // margin: EdgeInsets.all(10),
                            padding: EdgeInsets.all(5),
                            height: 40,
                            width: MediaQuery.of(context).size.width * 0.15,
                            decoration: BoxDecoration(
                              // color: Colors.white,
                              border: Border.all(color:primaryColorOfApp, width: 1.0),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(Icons.insert_drive_file,color: Colors.black,size: 20,),
                                SizedBox(width: 5,),
                                Expanded(
                                  child: Text(
                                    // 'Thrivers',
                                    'For Someone Else',
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.montserrat(
                                        textStyle:
                                        Theme.of(context).textTheme.bodySmall,
                                        color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                          ),

                        ),

                      ],
                    ),
                  ),

                  Divider(color: Colors.black26,),

                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Text("Date: ",
                                  style: GoogleFonts.montserrat(textStyle: Theme
                                      .of(context)
                                      .textTheme
                                      .titleMedium,fontWeight: FontWeight.w700)),
                            ),
                            Expanded(
                              flex: 4,
                              child: Text("${formattedDate}",
                                  style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.bodyLarge,
                                  )),
                            ),
                          ],
                        ),
                        SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Text("Email: ",
                                  style: GoogleFonts.montserrat(textStyle: Theme
                                      .of(context)
                                      .textTheme
                                      .titleMedium,fontWeight: FontWeight.w700)),
                            ),
                            Expanded(
                              flex: 4,
                              child: Text("${previewProvider.email==null ? "" : previewProvider.email}",
                                  style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.bodyLarge,)),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Text("Name: ",
                                  style: GoogleFonts.montserrat(textStyle: Theme
                                      .of(context)
                                      .textTheme
                                      .titleMedium,fontWeight: FontWeight.w700)),
                            ),
                            Expanded(
                              flex: 4,
                              child: Text("${previewProvider.name==null ? "" : previewProvider.name}",
                                  style: GoogleFonts.montserrat(textStyle: Theme
                                      .of(context)
                                      .textTheme
                                      .bodyLarge,)),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Text("Employer: ",
                                  style: GoogleFonts.montserrat(textStyle: Theme
                                      .of(context)
                                      .textTheme
                                      .titleMedium,fontWeight: FontWeight.w700)),
                            ),
                            Expanded(
                              flex: 4,
                              child: Text("${previewProvider.employer==null ? "" : previewProvider.employer}",
                                  style: GoogleFonts.montserrat(textStyle: Theme
                                      .of(context)
                                      .textTheme
                                      .bodyLarge,)),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Text("Division or section: ",
                                  style: GoogleFonts.montserrat(textStyle: Theme
                                      .of(context)
                                      .textTheme
                                      .titleMedium,fontWeight: FontWeight.w700)),
                            ),
                            Expanded(
                              flex: 4,
                              child: Text("${previewProvider.division==null ? "" : previewProvider.division}",
                                  style: GoogleFonts.montserrat(textStyle: Theme
                                      .of(context)
                                      .textTheme
                                      .bodyLarge,)),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,

                          children: [
                            Expanded(
                              flex: 1,
                              child: Text("Role: ",
                                  style: GoogleFonts.montserrat(textStyle: Theme
                                      .of(context)
                                      .textTheme
                                      .titleMedium,fontWeight: FontWeight.w700)),
                            ),
                            Expanded(
                              flex: 4,
                              child: Text("${previewProvider.role==null ? "" : previewProvider.role}",
                                  style: GoogleFonts.montserrat(textStyle: Theme
                                      .of(context)
                                      .textTheme
                                      .bodyLarge,)),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,

                          children: [
                            Expanded(
                              flex: 1,
                              child: Text("Location: ",
                                  style: GoogleFonts.montserrat(textStyle: Theme
                                      .of(context)
                                      .textTheme
                                      .titleMedium,fontWeight: FontWeight.w700)),
                            ),
                            Expanded(
                              flex: 4,
                              child: Text("${previewProvider.location==null ? "" : previewProvider.location}",
                                  style: GoogleFonts.montserrat(textStyle: Theme
                                      .of(context)
                                      .textTheme
                                      .bodyLarge,)),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Text("Employee number: ",
                                  style: GoogleFonts.montserrat(textStyle: Theme
                                      .of(context)
                                      .textTheme
                                      .titleMedium,fontWeight: FontWeight.w700)),
                            ),
                            Expanded(
                              flex: 4,
                              child: Text("${previewProvider.employeeNumber==null ? "" : previewProvider.employeeNumber}",
                                  style: GoogleFonts.montserrat(textStyle: Theme
                                      .of(context)
                                      .textTheme
                                      .bodyLarge,)),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Text("Line manager:",
                                  style: GoogleFonts.montserrat(textStyle: Theme
                                      .of(context)
                                      .textTheme
                                      .titleMedium,fontWeight: FontWeight.w700)),
                            ),
                            Expanded(
                              flex: 4,
                              child: Text("${previewProvider.linemanager==null ? "" : previewProvider.linemanager}",
                                  style: GoogleFonts.montserrat(textStyle: Theme
                                      .of(context)
                                      .textTheme
                                      .bodyLarge,)),
                            ),
                          ],
                        ),

                      ],
                    ),
                  ),

                  SizedBox(height: 15,),

                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text("Performing to my best in my role : ",
                        style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.blue)),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: TextField(
                      controller: AboutMeDescriptiontextController,
                      onChanged: (value) {
                        // _previewProvider.updatetitle(value);
                      },
                      maxLines: 6,
                      style: GoogleFonts.montserrat(
                          textStyle: Theme.of(context).textTheme.bodySmall,
                          fontWeight: FontWeight.w400,
                          color: Colors.black),
                      decoration: InputDecoration(
                        hintText: "$message",
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(10)),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black12),
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),


                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 5),
                          child: Text("To perform to my best in my role, I’d like to share this information about me:",
                              style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.blue)),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 5),
                          child: Text("Me and My circumstances: ",
                              style: GoogleFonts.montserrat(textStyle: Theme
                                  .of(context)
                                  .textTheme
                                  .titleMedium,)),
                        ),
                        SizedBox(height: 5,),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5),
                          child: Text("${previewProvider.mycircumstance==null ? "" : previewProvider.mycircumstance}",
                              style: GoogleFonts.montserrat(textStyle: Theme
                                  .of(context)
                                  .textTheme
                                  .bodyLarge,)),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 5),
                          child: Text("My strengths that I want to have the opportunity to use in my role: ",
                              style: GoogleFonts.montserrat(textStyle: Theme
                                  .of(context)
                                  .textTheme
                                  .titleMedium,)),
                        ),
                        SizedBox(height: 5,),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5),
                          child: Text("${previewProvider.mystrength==null ? "" : previewProvider.mystrength}",
                              style: GoogleFonts.montserrat(textStyle: Theme
                                  .of(context)
                                  .textTheme
                                  .bodyLarge,)),

                        ),


                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 5),
                                child: Text("Things I find challenging in life that make it harder for me to perform my best:",
                                    style: GoogleFonts.montserrat(textStyle: Theme
                                        .of(context)
                                        .textTheme
                                        .titleMedium,)),
                              ),
                              Consumer<PreviewProvider>(
                                builder: (context, previewProvider, _) {
                                  // solutions = userAboutMEProvider.getSelectedSolutions();
                                  print("PreviewChallengesList : ${previewProvider.PreviewChallengesList}");


                                  return Container(
                                    // height: MediaQuery.of(context).size.height * .6,
                                    width: MediaQuery.of(context).size.width ,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black26),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    // width: MediaQuery.of(context).size.width,
                                    child:SingleChildScrollView(
                                      child: DataTable(
                                        dataRowMaxHeight:60 ,
                                        headingTextStyle: GoogleFonts.montserrat(
                                            textStyle: Theme.of(context).textTheme.titleMedium,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black),
                                        columnSpacing: 15,
                                        columns: [
                                          DataColumn(
                                            label: Container(
                                              // color: Colors.blue,
                                              // width: 60,
                                              child: Text('Id',textAlign: TextAlign.center,),
                                            ),

                                          ),
                                          DataColumn(
                                            label: Container(
                                              // width: 180,
                                              child: Text('Label',),
                                            ),
                                          ),
                                          DataColumn(
                                            label: Text('Impact',),
                                          ),
                                          DataColumn(
                                            label: Container(
                                              // width: 400,
                                                child: Text('Description')
                                            ),
                                          ),
                                          DataColumn(
                                            label: Container(
                                              // width: 400,
                                                child: Text('Impact on me')
                                            ),
                                          ),
                                          DataColumn(
                                            label: Container(
                                              // width: 400,
                                                child: Text('Attachment')
                                            ),
                                          ),


                                        ],

                                        rows: previewProvider.PreviewChallengesList.map((solution) {
                                          int index = previewProvider.PreviewChallengesList.indexOf(solution);


                                          // print(jsonString);

                                          id = solution['id'];
                                          Label = solution['Label'];
                                          Impact = solution['Impact'];
                                          Final_description = solution['Final_description'];
                                          Impact_on_me = solution['Impact_on_me'];
                                          Attachment = solution['Attachment'];

                                          return DataRow(
                                            cells: [
                                              DataCell(
                                                  Container(
                                                    // width: 60,
                                                      child: Text("CH0${solution['id']}.", style: GoogleFonts.montserrat(
                                                        // child: Text("${index + 1}.", style: GoogleFonts.montserrat(
                                                          textStyle: Theme.of(context).textTheme.bodySmall,
                                                          fontWeight: FontWeight.w600,
                                                          color: Colors.black),))),
                                              DataCell(
                                                  Container(
                                                    // width: 180,
                                                      child: Text(solution['Label'],
                                                          overflow: TextOverflow.ellipsis,maxLines: 2,
                                                          style: GoogleFonts.montserrat(
                                                              textStyle: Theme.of(context).textTheme.bodySmall,
                                                              fontWeight: FontWeight.w600,
                                                              color: Colors.black)
                                                      ))),
                                              DataCell(
                                                  Container(
                                                    // width: 400,
                                                      child: Text(solution['Impact'],
                                                          overflow: TextOverflow.ellipsis,maxLines: 2,
                                                          style: GoogleFonts.montserrat(
                                                              textStyle: Theme.of(context).textTheme.bodySmall,
                                                              fontWeight: FontWeight.w600,
                                                              color: Colors.black)
                                                      ))),
                                              DataCell(
                                                  Container(
                                                    // width: 400,
                                                      child: Text(solution['Final_description'],
                                                          overflow: TextOverflow.ellipsis,maxLines: 2,
                                                          style: GoogleFonts.montserrat(
                                                              textStyle: Theme.of(context).textTheme.bodySmall,
                                                              fontWeight: FontWeight.w600,
                                                              color: Colors.black)
                                                      ))),

                                              DataCell(
                                                  Container(
                                                    // width: 400,
                                                      child: Text(solution['Impact_on_me'],
                                                          overflow: TextOverflow.ellipsis,maxLines: 2,
                                                          style: GoogleFonts.montserrat(
                                                              textStyle: Theme.of(context).textTheme.bodySmall,
                                                              fontWeight: FontWeight.w600,
                                                              color: Colors.black)
                                                      ))),

                                              DataCell(
                                                  Container(
                                                    // width: 400,
                                                      child: Text(solution['Attachment'],
                                                          overflow: TextOverflow.ellipsis,maxLines: 2,
                                                          style: GoogleFonts.montserrat(
                                                              textStyle: Theme.of(context).textTheme.bodySmall,
                                                              fontWeight: FontWeight.w600,
                                                              color: Colors.black)
                                                      ))),

                                              // DataCell(
                                              //   Container(
                                              //     // height: 100,
                                              //     margin: EdgeInsets.all(5),
                                              //     width: 140,
                                              //     child: Center(
                                              //       child: TextField(
                                              //         maxLines: 4,
                                              //         controller: TextEditingController(text: solution.notes),
                                              //         onChanged: (value) {
                                              //         },
                                              //         style: GoogleFonts.montserrat(
                                              //             textStyle: Theme
                                              //                 .of(context)
                                              //                 .textTheme
                                              //                 .bodySmall,
                                              //             fontWeight: FontWeight.w400,
                                              //             color: Colors.black),
                                              //         decoration: InputDecoration(
                                              //           contentPadding: EdgeInsets.all(10),
                                              //           // labelText: "Name",
                                              //           hintText: "Notes",
                                              //           errorStyle: GoogleFonts.montserrat(
                                              //               textStyle: Theme
                                              //                   .of(context)
                                              //                   .textTheme
                                              //                   .bodyLarge,
                                              //               fontWeight: FontWeight.w400,
                                              //               color: Colors.redAccent),
                                              //           focusedBorder: OutlineInputBorder(
                                              //               borderSide: BorderSide(color: Colors.black),
                                              //               borderRadius: BorderRadius.circular(5)),
                                              //           border: OutlineInputBorder(
                                              //               borderSide: BorderSide(color: Colors.black12),
                                              //               borderRadius: BorderRadius.circular(5)),
                                              //           labelStyle: GoogleFonts.montserrat(
                                              //               textStyle: Theme
                                              //                   .of(context)
                                              //                   .textTheme
                                              //                   .bodyLarge,
                                              //               fontWeight: FontWeight.w400,
                                              //               color: Colors.black),
                                              //         ),
                                              //       ),
                                              //     ),
                                              //   ),), // Empty cell for Notes

                                              // DataCell(
                                              //     Container(
                                              //       child: IconButton(
                                              //         onPressed: (){
                                              //
                                              //         },
                                              //         icon: Icon(Icons.add),
                                              //       ),
                                              //     )),  // Empty cell for Attachments
                                              // DataCell(
                                              //   Container(
                                              //     width: 120,
                                              //     child: DropdownButton(
                                              //       style: TextStyle(fontSize: 12,overflow: TextOverflow.ellipsis),
                                              //       // value: selectedProvider,
                                              //       value: selectedProviderValues[index],
                                              //       onChanged: (newValue) {
                                              //         // userAboutMEProvider.updatevalue(selectedProviderValues[index], newValue.toString());
                                              //         setState(() {
                                              //           // selectedProvider = newValue.toString();
                                              //           selectedProviderValues[index] = newValue.toString();
                                              //         });
                                              //       },
                                              //       items: provider.map((option) {
                                              //         return DropdownMenuItem(
                                              //           value: option,
                                              //           child: Text(option, overflow: TextOverflow.ellipsis,maxLines: 2,),
                                              //         );
                                              //       }).toList(),
                                              //     ),
                                              //   ),
                                              // ),  // Empty cell for Provider
                                              // DataCell(
                                              //   Container(
                                              //     width: 60,
                                              //     child: DropdownButton(
                                              //       style: TextStyle(fontSize: 12,overflow: TextOverflow.ellipsis),
                                              //       value: selectedInPlaceValues[index],
                                              //       // value: selectedInPlace,
                                              //       onChanged: (newValue) {
                                              //         setState(() {
                                              //           selectedInPlaceValues[index] = newValue.toString();
                                              //           // selectedInPlace = newValue.toString();
                                              //         });
                                              //       },
                                              //       items: InPlace.map((option) {
                                              //         return DropdownMenuItem(
                                              //           value: option,
                                              //           child: Text(option),
                                              //         );
                                              //       }).toList(),
                                              //     ),
                                              //   ),
                                              // ),  // Empty cell for In Place
                                              // DataCell(
                                              //   Container(
                                              //     width: 140,
                                              //     // child:  DropdownButton(
                                              //     //   style: TextStyle(fontSize: 12,overflow: TextOverflow.ellipsis),
                                              //     //   value: selectedPriorityValues[index],
                                              //     //   // value: selectedPriority,
                                              //     //   onChanged: (newValue) {
                                              //     //     setState(() {
                                              //     //       selectedPriorityValues[index] = newValue.toString();
                                              //     //
                                              //     //       print("$index: ${selectedPriorityValues[index]} ");
                                              //     //       // selectedPriority = newValue.toString();
                                              //     //     });
                                              //     //   },
                                              //     //   items: Priority.map((option) {
                                              //     //     return DropdownMenuItem(
                                              //     //       value: option,
                                              //     //       child: Text(option, overflow: TextOverflow.ellipsis,),
                                              //     //     );
                                              //     //   }).toList(),
                                              //     // ),
                                              //     child:  DropdownButtonFormField(
                                              //       style: TextStyle(fontSize: 12,overflow: TextOverflow.ellipsis),
                                              //       decoration: InputDecoration(
                                              //
                                              //         hintText: 'Priority',
                                              //       ),
                                              //       value: userAboutMEProvider.selectedPriorityValues[index],
                                              //       onChanged: (newValue) {
                                              //         userAboutMEProvider.updateSelectedPriorityValues(index, newValue);
                                              //         print('priority ${index} and ${userAboutMEProvider.selectedPriorityValues}');
                                              //       },
                                              //       icon: Icon(Icons.keyboard_arrow_down_outlined,size: 20,),
                                              //       items: selectedPriorityValues.map<DropdownMenuItem<String>>((String value) {
                                              //         // String displayedText = value;
                                              //         // if (displayedText.length > 5) {
                                              //         //   // Limit the displayed text to 10 characters and add ellipsis
                                              //         //   displayedText = displayedText.substring(0, 5) + '..';
                                              //         // }
                                              //         return DropdownMenuItem<String>(
                                              //           value: value,
                                              //           child: Text(value, overflow: TextOverflow.ellipsis,),
                                              //         );
                                              //       }).toList(),
                                              //     ),
                                              //   ),
                                              // ),  // Empty cell for Priority

                                            ],
                                          );
                                        }).toList(),
                                      ),
                                    ),

                                  );
                                },
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 5,),

                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 5),
                          child: Text("What I value about [my organisation] and workplace environment that helps me perform to my best: ",
                              style: GoogleFonts.montserrat(textStyle: Theme
                                  .of(context)
                                  .textTheme
                                  .titleMedium,)),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5),
                          child: Text("${previewProvider.myorganization==null ? "" : previewProvider.myorganization}",
                              style: GoogleFonts.montserrat(textStyle: Theme
                                  .of(context)
                                  .textTheme
                                  .bodyLarge,fontWeight: FontWeight.w700)),

                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 5),
                          child: Text("What I find challenging about [My Organisation] and the workplace environment that makes it harder for me to perform my best: ",
                              style: GoogleFonts.montserrat(textStyle: Theme
                                  .of(context)
                                  .textTheme
                                  .titleMedium,)),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5),
                          child: Text("${previewProvider.mychallenge==null ? "" : previewProvider.mychallenge}",
                              style: GoogleFonts.montserrat(textStyle: Theme
                                  .of(context)
                                  .textTheme
                                  .bodyLarge,fontWeight: FontWeight.w700)),

                        ),
                      ],
                    ),
                  ),


                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 5),
                          child: Text("Actions and adjustments that I’ve identified can help me perform to my best in myrole for :",
                              style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.blue)),
                        ),
                        Consumer<PreviewProvider>(
                          builder: (context, previewProvider, _) {
                            print("PreviewSolutionList : ${previewProvider.PreviewSolutionList}");


                            return Container(
                              // height: 350,
                              // height: MediaQuery.of(context).size.height * .48,
                              width: MediaQuery.of(context).size.width,

                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black26),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              // width: MediaQuery.of(context).size.width,
                              child:SingleChildScrollView(
                                child: DataTable(
                                  dataRowMaxHeight:60 ,
                                  headingTextStyle: GoogleFonts.montserrat(
                                      textStyle: Theme.of(context).textTheme.titleMedium,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black),
                                  // border: TableBorder.all(color: Colors.black),
                                  columnSpacing: 15,
                                  columns: [

                                    DataColumn(
                                      label: Container(
                                        // color: Colors.blue,
                                        // width: 60,
                                        child: Text('Id',textAlign: TextAlign.center,),
                                      ),

                                    ),
                                    DataColumn(
                                      label: Container(
                                        // width: 180,
                                        child: Text('label',),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Container(
                                        // width: 250,
                                        child: Text('Impact',),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Container(
                                        // width: 400,
                                          child: Text('Description')
                                      ),
                                    ),
                                    DataColumn(
                                      label: Container(
                                        // width: 400,
                                          child: Text('Provider')
                                      ),
                                    ),
                                    DataColumn(
                                      label: Flexible(
                                        // width: 400,
                                          child: Text('In Place')
                                      ),
                                    ),
                                    DataColumn(
                                      label: Container(
                                        // width: 400,
                                          child: Text('Attachment')
                                      ),
                                    ),
                                  ],
                                  rows: previewProvider.PreviewSolutionList.map((challenge) {
                                    int index = previewProvider.PreviewSolutionList.indexOf(challenge);
                                    // print(jsonString);
                                    return DataRow(
                                      cells: [
                                        DataCell(
                                            Container(
                                              // width: 60,
                                              //   child: Text("${index + 1}.", style: GoogleFonts.montserrat(
                                                child: Text("SH0${challenge['id']}.", style: GoogleFonts.montserrat(
                                                    textStyle: Theme.of(context).textTheme.bodySmall,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black),))
                                        ),
                                        DataCell(
                                            Container(
                                              child: Text(challenge['Label'],
                                                  overflow: TextOverflow.ellipsis,maxLines: 2,
                                                  style: GoogleFonts.montserrat(
                                                      textStyle: Theme.of(context).textTheme.bodySmall,
                                                      fontWeight: FontWeight.w600,
                                                      color: Colors.black)
                                              ),
                                            )),
                                        DataCell(
                                            Container(
                                              // width: 250,
                                                child: Text(challenge["Impact"],
                                                    overflow: TextOverflow.ellipsis,maxLines: 2,
                                                    style: GoogleFonts.montserrat(
                                                        textStyle: Theme.of(context).textTheme.bodySmall,
                                                        fontWeight: FontWeight.w600,
                                                        color: Colors.black)
                                                ))),
                                        DataCell(
                                            Container(
                                              // width: 400,
                                                child: Text(challenge['Final_description'],
                                                    overflow: TextOverflow.ellipsis,maxLines: 2,
                                                    style: GoogleFonts.montserrat(
                                                        textStyle: Theme.of(context).textTheme.bodySmall,
                                                        fontWeight: FontWeight.w600,
                                                        color: Colors.black)
                                                ))),
                                        DataCell(
                                            Container(
                                              // width: 400,
                                                child: Text(challenge['Provider']==null ? "" : challenge['Provider'],
                                                    overflow: TextOverflow.ellipsis,maxLines: 2,
                                                    style: GoogleFonts.montserrat(
                                                        textStyle: Theme.of(context).textTheme.bodySmall,
                                                        fontWeight: FontWeight.w600,
                                                        color: Colors.black)
                                                ))),
                                        DataCell(
                                            Container(
                                              // width: 400,
                                                child: Text(challenge['InPlace']==null ? "" : challenge['InPlace'],
                                                    overflow: TextOverflow.ellipsis,maxLines: 2,
                                                    style: GoogleFonts.montserrat(
                                                        textStyle: Theme.of(context).textTheme.bodySmall,
                                                        fontWeight: FontWeight.w600,
                                                        color: Colors.black)
                                                ))),
                                        DataCell(
                                            Container(
                                              // width: 400,
                                                child: Text(challenge['Attachment']==null ? "" : challenge['Attachment'],
                                                    overflow: TextOverflow.ellipsis,maxLines: 2,
                                                    style: GoogleFonts.montserrat(
                                                        textStyle: Theme.of(context).textTheme.bodySmall,
                                                        fontWeight: FontWeight.w600,
                                                        color: Colors.black)
                                                ))),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),

                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 5),
                    child: TextField(
                      controller: AboutMeUseFulInfotextController,
                      onChanged: (value) {
                        _previewProvider.updatetitle(value);
                      },
                      style: GoogleFonts.montserrat(
                          textStyle: Theme.of(context).textTheme.bodySmall,
                          fontWeight: FontWeight.w400,
                          color: Colors.black),
                      decoration: InputDecoration(
                        hintText: "Links/Document/Product Info",
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(10)),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black12),
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),

                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5),
                        child: Text("Attachments :", style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.titleSmall,)),
                      ),
                      SizedBox(width: 10,),

                      // InkWell(
                      //   onTap: (){
                      //     // _userAboutMEProvider.pickFiles();
                      //   },
                      //   child: Container(
                      //     // padding: EdgeInsets.all(20),
                      //     child: Center(child: Icon(Icons.add, size: 30, color: Colors.white,)),
                      //     width: 30,
                      //     height: 30,
                      //     decoration: BoxDecoration(
                      //       color: Colors.blue,
                      //       borderRadius: BorderRadius.circular(50),
                      //     ),
                      //   ),
                      // ),
                      IconButton(onPressed: (){},
                        icon: Container(
                          // padding: EdgeInsets.all(20),
                          child: Center(child: Icon(Icons.add, size: 30, color: Colors.white,)),
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        tooltip: "Medical and Personal",
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("${_userAboutMEProvider.aadhar==null ? "" : _userAboutMEProvider.aadhar}", style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.titleSmall,)),
                    // child: Text("document.pdf", style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.titleSmall,)),
                  ),
                  SizedBox(height: 10,),

                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [

                        // Text("5. Preview",
                        //     style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,
                        //         fontSize: 30,
                        //         color: Colors.black)),

                        InkWell(
                          onTap: () async {

                            var createdAt = DateFormat('yyyy-MM-dd, hh:mm').format(DateTime.now());

                            Map<String, dynamic> AboutMEDatas = {
                              'About_Me_Label': AboutMeLabeltextController.text,
                              'AB_Status' : "Complete",
                              'AB_Description' : AboutMeDescriptiontextController.text,
                              'AB_Useful_Info' : AboutMeUseFulInfotextController.text,
                              'AB_Attachment' : "",
                            };

                            String solutionJson = json.encode(AboutMEDatas);
                            print(solutionJson);

                            ProgressDialog.show(context, "Completing", Icons.save);
                            await ApiRepository().updateAboutMe(AboutMEDatas,documentId);

                            ProgressDialog.hide();

                            sendMailPopUp(challengesList,solutionsList);

                            // selectedEmail = null;
                            // nameController.clear();
                            // searchEmailcontroller.clear();
                            // employerController.clear();
                            // divisionOrSectionController.clear();
                            // RoleController.clear();
                            // LocationController.clear();
                            // EmployeeNumberController.clear();
                            // LineManagerController.clear();
                            // mycircumstancesController.clear();
                            // MystrengthsController.clear();
                            // mycircumstancesController.clear();
                            // AboutMeLabeltextController.clear();
                            // RefineController.clear();
                            // solutionsList.clear();
                            // _userAboutMEProvider.solutionss.clear();
                            // _userAboutMEProvider.challengess.clear();
                            // _userAboutMEProvider.combinedSolutionsResults.clear();
                            // _userAboutMEProvider.combinedResults.clear();
                            // previewProvider.email=null;
                            // previewProvider.name=null;
                            // previewProvider.employer=null;
                            // previewProvider.division=null;
                            // previewProvider.role=null;
                            // previewProvider.location=null;
                            // previewProvider.employeeNumber=null ;
                            // previewProvider.linemanager=null;
                            // previewProvider.title=null;
                            // previewProvider.mycircumstance=null;
                            // previewProvider.mystrength=null ;
                            // previewProvider.myorganization=null ;
                            // previewProvider.mychallenge=null ;
                            // previewProvider.PreviewChallengesList.clear();
                            // previewProvider.PreviewSolutionList.clear();
                            // // _navigateToTab(0);
                            // // Navigator.pop(context);
                            // setState(() {
                            //   page.jumpToPage(1);
                            // });
                          },
                          child:Container(
                            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                            width: MediaQuery.of(context).size.width * .15,
                            decoration: BoxDecoration(
                              color:Colors.blue ,
                              border: Border.all(
                                  color:Colors.blue ,
                                  width: 1.0),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Center(
                              child:Text(
                                'Complete and Send',
                                style: GoogleFonts.montserrat(
                                  textStyle:
                                  Theme
                                      .of(context)
                                      .textTheme
                                      .titleSmall,
                                  fontWeight: FontWeight.bold,
                                  color:Colors.white ,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )

                ],
              ),
            ),
          );
        });
  }  /// this is new one
///
///


  pw.Table(
  border: pw.TableBorder.all(),
  children: [
  pw.TableRow(
  children: [
  pw.Container(
  width: 40,
  padding: const pw.EdgeInsets.all(8),
  child: pw.Text('Id'),
  ),
  pw.Container(
  width: 120,
  padding: const pw.EdgeInsets.all(8),
  child: pw.Text('Label'),
  ),
  pw.Container(
  width: 120,
  padding: const pw.EdgeInsets.all(8),
  child: pw.Text('Impact'),
  ),
  pw.Container(
  width: 150,
  padding: const pw.EdgeInsets.all(8),
  child: pw.Text('Description'),
  ),
  pw.Container(
  width: 120,
  padding: const pw.EdgeInsets.all(8),
  child: pw.Text('Impact on me'),
  ),
  pw.Container(
  width: 110,
  padding: const pw.EdgeInsets.all(8),
  child: pw.Text('Attachment'),
  ),
  // Add more cells as needed
  ],
  ),
  ...ChallengetableRows,
  // Add more rows as needed

  // Add Table Rows from dataList
  ],
  ),


  pw.Table(
  border: pw.TableBorder.all(),
  children: [
  pw.TableRow(
  children: [
  pw.Container(
  width: 40,
  padding: const pw.EdgeInsets.all(8),
  child: pw.Text('Id'),
  ),
  pw.Container(
  width: 110,
  padding: const pw.EdgeInsets.all(8),
  child: pw.Text('Label'),
  ),
  pw.Container(
  width: 100,
  padding: const pw.EdgeInsets.all(8),
  child: pw.Text('Impact'),
  ),
  pw.Container(
  width: 120,
  padding: const pw.EdgeInsets.all(8),
  child: pw.Text('Description'),
  ),
  pw.Container(
  width: 110,
  padding: const pw.EdgeInsets.all(8),
  child: pw.Text('Provider'),
  ),
  pw.Container(
  width: 90,
  padding: const pw.EdgeInsets.all(8),
  child: pw.Text('InPlace'),
  ),
  pw.Container(
  width: 110,
  padding: const pw.EdgeInsets.all(8),
  child: pw.Text('Attachment'),
  ),
  // Add more cells as needed
  ],
  ),
  ...SolutiontableRows,
  // Add more rows as needed

  // Add Table Rows from dataList
  ],
  ),


  Widget PreviewPages(aboutMeData){
  return Consumer<PreviewProvider>(
  builder: (c,previewProvider, _){

  String message = """
Dear ${employerController.text},

Thank you for recognising that our organisation performs better, and we achieve more together, when each of us feels safe and open to share what we need to be our best in the roles we are asked and agree to perform. This communication sets out what I think it would be helpful for you to know about me and includes what I believe helps me thrive, so that I can perform to my best, both for me and for ${employerController.text}.

In relation to performing to my very best, both to help me and ${employerController.text} to achieve the best we can, on the next two pages I have set out:
• information that I think it is helpful for me to share with my Team Leader and team colleagues, and
• actions and adjustments that I’ve identified can help me perform to my best in my role for ${employerController.text}.

Next steps:
I will arrange to have a meeting with my ${LineManagerController.text} to discuss my requests in person. This request includes accommodations that I view as reasonable adjustments under the Equality Act 2010.

Thank you for being open to understanding me better and for considering my requests.

Signed
Date
""";

  AboutMeDescriptiontextController.text.isEmpty ? AboutMeDescriptiontextController.text = message : "";


  // AboutMeLabeltextController.text = "${nameController.text} - draft communication to ${employerController.text}";

  return  Container(
  height: MediaQuery
      .of(context)
      .size
      .height,
  child: SingleChildScrollView(
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  SizedBox(height: 5,),
  // SizedBox(height: 20,),
  Row(
  mainAxisSize: MainAxisSize.min,
  mainAxisAlignment: MainAxisAlignment.start,
  // crossAxisAlignment: CrossAxisAlignment.start,
  children: [

  Container(
  width: MediaQuery.of(context).size.width * .12,
  child: Text("Purpose of report:   ", style: GoogleFonts.lato(
  textStyle: Theme.of(context).textTheme.titleMedium,
  fontStyle: FontStyle.italic,
  fontWeight: FontWeight.bold
  )),
  ),

  Flexible(
  child: Container(
  height: 40,
  width: MediaQuery.of(context).size.width * .25,
  child: TextField(
  controller: previewProvider.PurposeOfReporttextController,
  onChanged: (value) {
  // _previewProvider.updatetitle(value);
  AboutMeLabeltextController.text = previewProvider.PurposeOfReporttextController.text.length > 50
  ? previewProvider.PurposeOfReporttextController.text.substring(0, 50)
      : previewProvider.PurposeOfReporttextController.text;
  },
  style: GoogleFonts.lato(
  textStyle: Theme.of(context).textTheme.bodySmall,
  fontStyle: FontStyle.italic,
  fontWeight: FontWeight.w400,
  color: Colors.black),
  decoration: InputDecoration(
  hintText: "My discussion with ...." ,
  focusedBorder: OutlineInputBorder(
  borderSide: BorderSide(color: Colors.black),
  borderRadius: BorderRadius.circular(10)),
  border: OutlineInputBorder(
  borderSide: BorderSide(color: Colors.black12),
  borderRadius: BorderRadius.circular(10)),
  ),
  ),
  ),
  ),

  SizedBox(width: 20,),

  InkWell(
  onTap: (){
  previewProvider.updatePurposeofReport(LineManagerController.text);
  AboutMeLabeltextController.text = previewProvider.PurposeOfReporttextController.text.length > 50
  ? previewProvider.PurposeOfReporttextController.text.substring(0, 50)
      : previewProvider.PurposeOfReporttextController.text;
  previewProvider.purpose("Official");

  },
  child: Container(
  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
  // width: MediaQuery.of(context).size.width * .15,
  decoration: BoxDecoration(
  color:Colors.blue ,
  border: Border.all(
  color:Colors.blue ,
  width: 1.0),
  borderRadius: BorderRadius.circular(10.0),
  ),
  child: Center(
  child:Text(
  'Official communication to my employer',
  style: GoogleFonts.montserrat(
  textStyle:
  Theme
      .of(context)
      .textTheme
      .titleSmall,
  fontWeight: FontWeight.bold,
  color:Colors.white ,
  ),
  ),
  ),
  ),
  ),

  SizedBox(width: 10,),

  InkWell(
  onTap: (){
  previewProvider.updateOtherCommuniation(nameController.text,LineManagerController.text);
  AboutMeLabeltextController.text = previewProvider.PurposeOfReporttextController.text.length > 50
  ? previewProvider.PurposeOfReporttextController.text.substring(0, 50)
      : previewProvider.PurposeOfReporttextController.text;
  previewProvider.purpose("Others");

  },
  child: Container(
  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
  // width: MediaQuery.of(context).size.width * .15,
  decoration: BoxDecoration(
  color:Colors.blue ,
  border: Border.all(
  color:Colors.blue ,
  width: 1.0),
  borderRadius: BorderRadius.circular(10.0),
  ),
  child: Center(
  child:Text(
  'Other communication',
  style: GoogleFonts.montserrat(
  textStyle:
  Theme
      .of(context)
      .textTheme
      .titleSmall,
  fontWeight: FontWeight.bold,
  color:Colors.white ,
  ),
  ),
  ),
  ),
  ),

  // SizedBox(width: 10,),
  //
  // InkWell(
  //   onTap: () async {
  //     // sideMenu.changePage(2);
  //     // page.jumpToPage(1);
  //   },
  //   child: Container(
  //     // margin: EdgeInsets.all(10),
  //     padding: EdgeInsets.all(5),
  //     height: 40,
  //     width: MediaQuery.of(context).size.width * 0.15,
  //     decoration: BoxDecoration(
  //       // color: Colors.white,
  //       border: Border.all(color:primaryColorOfApp, width: 1.0),
  //       borderRadius: BorderRadius.circular(10.0),
  //     ),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       children: [
  //         Icon(Icons.insert_drive_file,color: Colors.black,size: 20,),
  //         SizedBox(width: 5,),
  //         Expanded(
  //           child: Text(
  //             // 'Thrivers',
  //             'For Someone Else',
  //             overflow: TextOverflow.ellipsis,
  //             style: GoogleFonts.montserrat(
  //                 textStyle:
  //                 Theme.of(context).textTheme.bodySmall,
  //                 color: Colors.black),
  //           ),
  //         ),
  //       ],
  //     ),
  //   ),
  //
  // ),

  ],
  ),

  // Divider(color: Colors.black26,),


  SizedBox(height: 5,),

  Container(
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  Row(
  mainAxisAlignment: MainAxisAlignment.start,
  children: [
  Container(
  width: MediaQuery.of(context).size.width * .12,
  child: Text("Date:   ",
  style: GoogleFonts.lato(textStyle: Theme
      .of(context)
      .textTheme
      .titleMedium,fontWeight: FontWeight.w700)),
  ),
  Flexible(
  flex: 1,
  child: Container(
  height: 40,
  width: MediaQuery.of(context).size.width * .19,
  child: TextField(
  controller: AboutMeDatetextController,
  style: GoogleFonts.lato(
  textStyle: Theme.of(context).textTheme.bodyLarge,
  color: Colors.black),
  decoration: InputDecoration(
  hintText: "" ,
  focusedBorder: OutlineInputBorder(
  borderSide: BorderSide(color: Colors.black),
  borderRadius: BorderRadius.circular(10)),
  border: OutlineInputBorder(
  borderSide: BorderSide(color: Colors.black12),
  borderRadius: BorderRadius.circular(10)),
  ),
  ),
  ),

  ),
  ],
  ),

  SizedBox(height: 15,),

  Text("Input email addresses of any colleagues to whom you want to send this report: ",style: GoogleFonts.lato(
  textStyle: Theme.of(context).textTheme.titleMedium, color: Colors.red,fontWeight: FontWeight.w500
  ),),

  Row(
  children: [
  Container(
  width: MediaQuery.of(context).size.width * .12,
  child: Text("To: ",style: GoogleFonts.lato(
  textStyle:
  Theme
      .of(context)
      .textTheme
      .titleMedium,
  fontWeight: FontWeight.w700
  ),),
  ),
  Expanded(
  child:Container(
  height: 40,
  width: MediaQuery.of(context).size.width * .19,
  child: TextField(
  controller: previewProvider.SendNametextController,

  style: GoogleFonts.lato(
  textStyle: Theme.of(context).textTheme.bodySmall,
  fontWeight: FontWeight.w400,
  color: Colors.black),
  decoration: InputDecoration(
  hintText: "Name",
  focusedBorder: OutlineInputBorder(
  borderSide: BorderSide(color: Colors.black),
  borderRadius: BorderRadius.circular(10)),
  border: OutlineInputBorder(
  borderSide: BorderSide(color: Colors.black12),
  borderRadius: BorderRadius.circular(10)),
  ),
  ),
  ),
  ),
  SizedBox(width: 5,),

  Expanded(
  child: Container(
  height: 40,
  width: MediaQuery.of(context).size.width * .19,
  child: TextField(
  controller: SendEmailtextController,
  style: GoogleFonts.lato(
  textStyle: Theme.of(context).textTheme.bodySmall,
  fontWeight: FontWeight.w400,
  color: Colors.black),
  decoration: InputDecoration(
  hintText: "Email",
  focusedBorder: OutlineInputBorder(
  borderSide: BorderSide(color: Colors.black),
  borderRadius: BorderRadius.circular(10)),
  border: OutlineInputBorder(
  borderSide: BorderSide(color: Colors.black12),
  borderRadius: BorderRadius.circular(10)),
  ),
  ),
  ),
  ),

  SizedBox(width: 5,),

  Container(
  padding: EdgeInsets.all(10),
  margin: EdgeInsets.all(11),
  width:  MediaQuery.of(context).size.width * .05,),



  ],
  ),
  SizedBox(height: 5,),

  Column(
  children: List.generate(
  previewProvider.ccEmails.length,
  (index) {
  return Row(
  children: [
  Container(
  width: MediaQuery.of(context).size.width * .12,
  child: Text(
  "Cc: ",
  style: GoogleFonts.lato(
  textStyle: Theme.of(context)
      .textTheme
      .titleMedium,
  fontWeight: FontWeight.w700),
  ),
  ),
  Expanded(
  flex: 3,
  child: Text(
  '${index + 1}. ${previewProvider.ccNames[index]}, <${previewProvider.ccEmails[index]}>'),
  ),
  // SizedBox(width: 50,),
  Flexible(
  flex: 2,
  child: InkWell(
  child: Text("remove",style: TextStyle(color: Colors.red)),
  onTap: () =>
  previewProvider.removeCCRecipient(index),
  ),
  ),
  ],
  );
  },
  ),
  ),

  Row(
  children: [
  Container(
  width: MediaQuery.of(context).size.width * 0.12,
  child: Text("Cc: ",style: GoogleFonts.lato(
  textStyle:
  Theme
      .of(context)
      .textTheme
      .titleMedium,
  fontWeight: FontWeight.w700
  ),),
  ),


  Expanded(
  child: Container(
  height: 40,
  width: MediaQuery.of(context).size.width * .19,
  child: TextField(
  controller: CopySendNametextController,

  style: GoogleFonts.lato(
  textStyle: Theme.of(context).textTheme.bodySmall,
  fontWeight: FontWeight.w400,
  color: Colors.black),
  decoration: InputDecoration(
  hintText: "Name",
  focusedBorder: OutlineInputBorder(
  borderSide: BorderSide(color: Colors.black),
  borderRadius: BorderRadius.circular(10)),
  border: OutlineInputBorder(
  borderSide: BorderSide(color: Colors.black12),
  borderRadius: BorderRadius.circular(10)),
  ),
  ),
  ),
  ),

  SizedBox(width: 5,),

  Expanded(
  child: Container(
  height: 40,
  width: MediaQuery.of(context).size.width * .19,
  child: TextField(
  controller: CopySendEmailtextController,
  style: GoogleFonts.lato(
  textStyle: Theme.of(context).textTheme.bodySmall,
  fontWeight: FontWeight.w400,
  color: Colors.black),
  decoration: InputDecoration(
  hintText: "Email",
  focusedBorder: OutlineInputBorder(
  borderSide: BorderSide(color: Colors.black),
  borderRadius: BorderRadius.circular(10)),
  border: OutlineInputBorder(
  borderSide: BorderSide(color: Colors.black12),
  borderRadius: BorderRadius.circular(10)),
  ),
  ),
  ),
  ),

  SizedBox(width: 5,),

  InkWell(
  onTap: () {
  previewProvider.addCCRecipient(
  CopySendEmailtextController.text,
  CopySendNametextController.text);
  CopySendEmailtextController.clear();
  CopySendNametextController.clear();
  },
  child: Container(
  width: MediaQuery.of(context).size.width * 0.05,
  padding: EdgeInsets.all(10),
  margin: EdgeInsets.all(11),
  decoration: BoxDecoration(
  color: Colors.blue,
  borderRadius: BorderRadius.circular(10)
  ),
  child: Text('Add',
  textAlign: TextAlign.center,style: GoogleFonts.montserrat(
  textStyle: Theme.of(context).textTheme.titleSmall,
  fontWeight: FontWeight.bold,
  color: Colors.white),
  )
  ),
  ),

  ],
  ),


  SizedBox(height: 10,),
  Row(
  mainAxisAlignment: MainAxisAlignment.start,
  children: [
  Container(
  width: MediaQuery.of(context).size.width * .12,
  child: Text("Name: ",
  style: GoogleFonts.lato(textStyle: Theme
      .of(context)
      .textTheme
      .titleMedium,fontWeight: FontWeight.w700)),
  ),
  Expanded(
  flex: 5,
  child: Text("${previewProvider.name==null ? "" : previewProvider.name}",
  style: GoogleFonts.lato(textStyle: Theme
      .of(context)
      .textTheme
      .bodyLarge,)),
  ),
  ],
  ),

  Row(
  mainAxisAlignment: MainAxisAlignment.start,

  children: [
  Container(
  width: MediaQuery.of(context).size.width * .12,
  child: Text("Role: ",
  style: GoogleFonts.lato(textStyle: Theme
      .of(context)
      .textTheme
      .titleMedium,fontWeight: FontWeight.w700)),
  ),
  Expanded(
  flex: 5,
  child: Text("${previewProvider.role==null ? "" : previewProvider.role}",
  style: GoogleFonts.lato(textStyle: Theme
      .of(context)
      .textTheme
      .bodyLarge,)),
  ),
  ],
  ),

  Row(
  mainAxisAlignment: MainAxisAlignment.start,

  children: [
  Container(
  width: MediaQuery.of(context).size.width * .12,
  child: Text("Location: ",
  style: GoogleFonts.lato(textStyle: Theme
      .of(context)
      .textTheme
      .titleMedium,fontWeight: FontWeight.w700)),
  ),
  Expanded(
  flex: 5,
  child: Text("${previewProvider.location==null ? "" : previewProvider.location}",
  style: GoogleFonts.lato(textStyle: Theme
      .of(context)
      .textTheme
      .bodyLarge,)),
  ),
  ],
  ),

  Row(
  mainAxisAlignment: MainAxisAlignment.start,
  children: [
  Container(
  width: MediaQuery.of(context).size.width * .12,
  child: Text("Employee number: ",
  style: GoogleFonts.lato(textStyle: Theme
      .of(context)
      .textTheme
      .titleMedium,fontWeight: FontWeight.w700)),
  ),
  Expanded(
  flex: 5,
  child: Text("${previewProvider.employeeNumber==null ? "" : previewProvider.employeeNumber}",
  style: GoogleFonts.lato(textStyle: Theme
      .of(context)
      .textTheme
      .bodyLarge,)),
  ),
  ],
  ),
  Row(
  mainAxisAlignment: MainAxisAlignment.start,
  children: [
  Container(
  width: MediaQuery.of(context).size.width * .12,
  child: Text("Team Leader:",
  style: GoogleFonts.lato(textStyle: Theme
      .of(context)
      .textTheme
      .titleMedium,fontWeight: FontWeight.w700)),
  ),
  Expanded(
  flex: 5,
  child: Text("${previewProvider.linemanager==null ? "" : previewProvider.linemanager}",
  style: GoogleFonts.lato(textStyle: Theme
      .of(context)
      .textTheme
      .bodyLarge,)),
  ),
  ],
  ),

  ],
  ),
  ),

  SizedBox(height: 15,),

  Padding(
  padding: const EdgeInsets.all(5.0),
  child: Text("Performing to my best in my role for ${employerController.text}: ",
  style: GoogleFonts.lato(fontWeight: FontWeight.bold,
  // fontSize: 20,
  color: Colors.blue)),
  ),

  Padding(
  padding: const EdgeInsets.symmetric(horizontal: 5),
  child: TextField(
  controller: AboutMeDescriptiontextController,
  onChanged: (value) {
  // _previewProvider.updatetitle(value);
  },
  maxLines: 18,
  style: GoogleFonts.lato(
  textStyle: Theme.of(context).textTheme.bodyMedium,
  fontWeight: FontWeight.w400,
  color: Colors.black),
  decoration: InputDecoration(
  hintText: "$message",
  focusedBorder: OutlineInputBorder(
  borderSide: BorderSide(color: Colors.black),
  borderRadius: BorderRadius.circular(10)),
  border: OutlineInputBorder(
  borderSide: BorderSide(color: Colors.black12),
  borderRadius: BorderRadius.circular(10)),
  ),
  ),
  ),

  SizedBox(height: 10,),

  Container(
  width: MediaQuery.of(context).size.width,
  // padding: EdgeInsets.all(8),
  margin: EdgeInsets.all(5),
  decoration: BoxDecoration(
  border: Border.all(color:Colors.black,),
  borderRadius: BorderRadius.circular(10),
  ),
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,

  children: [
  Padding(
  padding: const EdgeInsets.symmetric(
  vertical: 10.0, horizontal: 5),
  child: Text("To perform to my best in my role, I’d like to share this information about me:",
  style: GoogleFonts.lato(fontWeight: FontWeight.bold,
  // fontSize: 20,
  color: Colors.blue)),
  ),
  Padding(
  padding: const EdgeInsets.symmetric(
  vertical: 10.0, horizontal: 5),
  child: Row(
  mainAxisAlignment: MainAxisAlignment.start,
  children: [
  Text("Me and my circumstances: ",
  style: GoogleFonts.lato(textStyle: Theme
      .of(context)
      .textTheme
      .titleMedium,
  decoration: TextDecoration.underline
  )),
  SizedBox(width: 50,),
  IconButton(
  onPressed: (){
  editmeandmycircumstances(aboutMeData);
  },
  icon: Icon(
  Icons.edit
  ))
  ],
  ),
  ),
  SizedBox(height: 5,),
  Padding(
  padding: const EdgeInsets.symmetric(
  horizontal: 5),
  child: Text("${previewProvider.mycircumstance==null ? "" : previewProvider.mycircumstance}",
  style: GoogleFonts.lato(textStyle: Theme
      .of(context)
      .textTheme
      .bodyMedium,fontWeight: FontWeight.w600
  )),
  ),
  Padding(
  padding: const EdgeInsets.symmetric(
  vertical: 10.0, horizontal: 5),
  child: Row(
  children: [
  Text("My strengths that I want to have the opportunity to use in my role: ",
  style: GoogleFonts.lato(textStyle: Theme
      .of(context)
      .textTheme
      .titleMedium,
  decoration: TextDecoration.underline
  )),
  SizedBox(width: 50,),
  IconButton(
  onPressed: (){
  editmystrength(aboutMeData);
  },
  icon: Icon(
  Icons.edit
  ))
  ],
  ),
  ),
  SizedBox(height: 5,),
  Padding(
  padding: const EdgeInsets.symmetric(
  horizontal: 5),
  child: Text("${previewProvider.mystrength==null ? "" : previewProvider.mystrength}",
  style: GoogleFonts.lato(textStyle: Theme
      .of(context)
      .textTheme
      .bodyMedium,fontWeight: FontWeight.w600
  )),

  ),


  Container(

  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  Padding(
  padding: const EdgeInsets.symmetric( vertical: 10.0,horizontal: 5),
  child: Text("Things I find challenging in life that make it harder for me to perform my best:",
  style: GoogleFonts.lato(textStyle: Theme
      .of(context)
      .textTheme
      .titleMedium,
  decoration: TextDecoration.underline
  ),
  ),
  ),
  SizedBox(height: 5,),

  Consumer<PreviewProvider>(
  builder: (context, previewProvider, _) {
  return Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: previewProvider.PreviewChallengesList.map((solution) {
  int index = previewProvider.PreviewChallengesList.indexOf(solution);

  return Padding(
  padding: EdgeInsets.only(bottom: 20.0),
  child: Row(
  children: [
  Flexible(
  child: RichText(
  maxLines: 4,
  text: TextSpan(
  children: [
  TextSpan(
  text: ' •  ',
  style:TextStyle(fontSize: 20)
  ),
  TextSpan(
  text: '${solution['Label']}',
  style: GoogleFonts.lato(textStyle: Theme
      .of(context)
      .textTheme
      .titleMedium,fontWeight: FontWeight.bold,)
  ),
  TextSpan(
  text: ' - ${solution['Final_description']}\n',
  style: GoogleFonts.lato(textStyle: Theme
      .of(context)
      .textTheme
      .bodyMedium,fontWeight: FontWeight.w400
  )
  ),
  TextSpan(
  text: '  ${solution['Impact_on_me']}',
  style: GoogleFonts.lato(textStyle: Theme
      .of(context)
      .textTheme
      .titleMedium,color: Colors.grey,)
  ),
  ],
  ),
  ),
  ),
  SizedBox(width: 50,),
  Row(
  children: [
  IconButton(
  icon: Icon(Icons.edit),
  onPressed: (){
  showEditconfirmChallengeDialogBox(solution['id'], solution['Label'] , solution['Description'],
  solution['Source'], solution['Challenge Status'], solution['tags'], solution['Created By'],
  solution['Created Date'], solution['Modified By'], solution['Modified Date'],
  solution['Original Description'], solution['Impact'], solution['Final_description'],
  solution['Category'], solution['Keywords'], solution['Potential Strengths'],
  solution['Hidden Strengths'], index, solution, solution['Impact_on_me']);
  },
  ),
  IconButton(
  icon: Icon(Icons.delete),
  onPressed: (){
  _userAboutMEProvider.removeEditConfirmChallenge(index,solution['id'],challengesList,_previewProvider.PreviewChallengesList);
  },
  )
  ],
  )
  ],
  ),
  );
  }).toList(),
  );
  },
  ),
  ],
  ),
  ),


  Padding(
  padding: const EdgeInsets.symmetric(
  vertical: 10.0, horizontal: 5),
  child: Row(
  children: [
  Text("What I value about ${employerController.text} and workplace environment that helps me perform to my best: ",
  style: GoogleFonts.lato(textStyle: Theme
      .of(context)
      .textTheme
      .titleMedium,
  decoration: TextDecoration.underline
  )),
  SizedBox(width: 50,),
  IconButton(
  onPressed: (){editmyorganization(aboutMeData);},
  icon: Icon(
  Icons.edit
  ))
  ],
  ),
  ),
  SizedBox(height: 5,),

  Padding(
  padding: const EdgeInsets.symmetric(
  horizontal: 5),
  child: Text("${previewProvider.myorganization==null ? "" : previewProvider.myorganization}",
  style: GoogleFonts.lato(textStyle: Theme
      .of(context)
      .textTheme
      .bodyMedium,fontWeight: FontWeight.w600
  )),
  ),
  Padding(
  padding: const EdgeInsets.symmetric(
  vertical: 10.0, horizontal: 5),
  child: Row(
  children: [
  Text("What I find challenging about ${employerController.text} and the workplace environment that makes it harder for me to perform my best: ",
  style: GoogleFonts.lato(textStyle: Theme
      .of(context)
      .textTheme
      .titleMedium,
  decoration: TextDecoration.underline
  )),
  SizedBox(width: 50,),
  IconButton(
  onPressed: (){editmychallenges(aboutMeData);},
  icon: Icon(
  Icons.edit
  ))
  ],
  ),
  ),
  SizedBox(height: 5,),

  Padding(
  padding: const EdgeInsets.symmetric(
  horizontal: 5),
  child: Text("${previewProvider.mychallenge==null ? "" : previewProvider.mychallenge}",
  style: GoogleFonts.lato(textStyle: Theme
      .of(context)
      .textTheme
      .bodyMedium,fontWeight: FontWeight.w600
  )),

  ),

  SizedBox(height: 10,),

  ],
  ),
  ),

  Container(
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,

  children: [
  Padding(
  padding: const EdgeInsets.symmetric(
  vertical: 10.0, horizontal: 5),
  child: Text("Actions and adjustments that I’ve identified can help me perform to my best in my role for ${employerController.text}:",
  style: GoogleFonts.lato(fontWeight: FontWeight.bold,
  // fontSize: 20,
  color: Colors.blue)),
  ),

  _previewProvider.PreviewSolutionMyResposibilty.isNotEmpty ?
  Container(
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  mainAxisAlignment: MainAxisAlignment.start,
  children: [
  Padding(
  padding: const EdgeInsets.symmetric(
  vertical: 10.0, horizontal: 5),
  child: Text("Personal Responsibility",
  style: GoogleFonts.lato(
  fontWeight: FontWeight.bold,
  // fontSize: 20,
  color: Colors.black,
  decoration: TextDecoration.underline
  ),
  ),
  ),
  Padding(
  padding: const EdgeInsets.symmetric(
  vertical: 10.0, horizontal: 5),
  child: Text("Things I already or will do to help myself: ",
  style: GoogleFonts.lato(
  textStyle: Theme
      .of(context)
      .textTheme
      .titleMedium
  )),
  ),
  Consumer<PreviewProvider>(
  builder: (context, previewProvider, _) {
  return Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: previewProvider.PreviewSolutionMyResposibilty.map((solution) {

  return Padding(
  padding: EdgeInsets.only(bottom: 20.0),
  child: Row(
  children: [
  Flexible(
  child: RichText(
  maxLines: 2,
  overflow: TextOverflow.ellipsis,
  text: TextSpan(
  children: [
  TextSpan(
  text: ' •  ',
  style: TextStyle(fontSize: 20)
  ),
  TextSpan(
  text: '${solution['Label']}',
  style: GoogleFonts.lato(textStyle: Theme
      .of(context)
      .textTheme
      .titleMedium,fontWeight: FontWeight.bold,)
  ),
  TextSpan(
  text: ' - ${solution['Final_description']}\n',
  style: GoogleFonts.lato(textStyle: Theme
      .of(context)
      .textTheme
      .bodyMedium,fontWeight: FontWeight.w400
  )
  ),
  TextSpan(
  text: '  ${solution['AboutMe_Notes']}',
  style: GoogleFonts.lato(
  textStyle: Theme
      .of(context)
      .textTheme
      .titleMedium,color: Colors.grey,),
  ),
  ],
  ),
  ),
  ),
  SizedBox(width: 50,),
  Row(
  children: [
  IconButton(
  icon: Icon(Icons.edit),
  onPressed: (){
  showEditconfirmSolutionsDialogBox(solution['id'], solution['Label'] , solution['Description'],
  solution['Source'], solution['Challenge Status'], solution['tags'], solution['Created By'],
  solution['Created Date'], solution['Modified By'], solution['Modified Date'],
  solution['Original Description'], solution['Impact'], solution['Final_description'],
  solution['Category'], solution['Keywords'], solution['Potential Strengths'],
  solution['Hidden Strengths'], solution, solution['AboutMe_Notes'],solution['Provider'],
  solution['InPlace']);
  },
  ),
  IconButton(
  icon: Icon(Icons.delete),
  onPressed: (){
  _userAboutMEProvider.removeEditConfirmSolution(solution["id"],solutionsList,
  _previewProvider.PreviewSolutionMyResposibilty,
  _previewProvider.PreviewSolutionStillNeeded,
  _previewProvider.PreviewSolutionNotNeededAnyMore,
  _previewProvider.PreviewSolutionNiceToHave,
  _previewProvider.PreviewSolutionMustHave,
  );
  },
  )
  ],
  )
  ],
  ),
  );
  }).toList(),
  );
  },
  ),
  ],
  ),
  ) : Container(),

  (_previewProvider.PreviewSolutionNotNeededAnyMore.isNotEmpty ||
  _previewProvider.PreviewSolutionMustHave.isNotEmpty ||
  _previewProvider.PreviewSolutionNiceToHave.isNotEmpty ||
  _previewProvider.PreviewSolutionStillNeeded.isNotEmpty ) ?
  Padding(
  padding: const EdgeInsets.symmetric(
  vertical: 10.0, horizontal: 5),
  child: Text("Requests of ${employerController.text}",
  style: GoogleFonts.lato(
  fontWeight: FontWeight.bold,
  decoration: TextDecoration.underline,
  // fontSize: 20,
  color: Colors.black)),
  ) : Container(),

  _previewProvider.PreviewSolutionStillNeeded.isNotEmpty ?
  Container(
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  mainAxisAlignment: MainAxisAlignment.start,
  children: [
  Padding(
  padding: const EdgeInsets.symmetric(
  vertical: 10.0, horizontal: 5),
  child: Text("${employerController.text} already provides the following assistance to me, which I’d like to continue to receive: ",
  style: GoogleFonts.lato(
  textStyle: Theme
      .of(context)
      .textTheme
      .titleMedium
  )),
  ),
  Consumer<PreviewProvider> (
  builder: (context, previewProvider, _) {
  return Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: previewProvider.PreviewSolutionStillNeeded.map((solution) {
  return Padding(
  padding: EdgeInsets.only(bottom: 20.0),
  child: Row(
  children: [
  Flexible(
  child: RichText(
  maxLines: 2,
  overflow: TextOverflow.ellipsis,
  text: TextSpan(
  children: [
  TextSpan(
  text: ' •  ',
  style: TextStyle(fontSize: 20)
  ),
  TextSpan(
  text: '${solution['Label']}',
  style: GoogleFonts.lato(textStyle: Theme
      .of(context)
      .textTheme
      .titleMedium,fontWeight: FontWeight.bold,)
  ),
  TextSpan(
  text: ' - ${solution['Final_description']}\n',
  style: GoogleFonts.lato(textStyle: Theme
      .of(context)
      .textTheme
      .bodyMedium,fontWeight: FontWeight.w400
  )
  ),
  TextSpan(
  text: '  ${solution['AboutMe_Notes']}',
  style: GoogleFonts.lato(textStyle: Theme
      .of(context)
      .textTheme
      .titleMedium,color: Colors.grey,)
  ),
  ],
  ),
  ),
  ),
  SizedBox(width: 50,),
  Row(
  children: [
  IconButton(
  icon: Icon(Icons.edit),
  onPressed: (){
  showEditconfirmSolutionsDialogBox(solution['id'], solution['Label'] , solution['Description'],
  solution['Source'], solution['Challenge Status'], solution['tags'], solution['Created By'],
  solution['Created Date'], solution['Modified By'], solution['Modified Date'],
  solution['Original Description'], solution['Impact'], solution['Final_description'],
  solution['Category'], solution['Keywords'], solution['Potential Strengths'],
  solution['Hidden Strengths'], solution, solution['AboutMe_Notes'],solution['Provider'],solution['InPlace']);
  },
  ),
  IconButton(
  icon: Icon(Icons.delete),
  onPressed: (){
  _userAboutMEProvider.removeEditConfirmSolution(solution["id"],solutionsList,
  _previewProvider.PreviewSolutionMyResposibilty,
  _previewProvider.PreviewSolutionStillNeeded,
  _previewProvider.PreviewSolutionNotNeededAnyMore,
  _previewProvider.PreviewSolutionNiceToHave,
  _previewProvider.PreviewSolutionMustHave,
  );
  },
  )
  ],
  )
  ],
  ),
  );
  }).toList(),
  );
  },
  ),
  ],
  ),
  ) : Container(),

  _previewProvider.PreviewSolutionMustHave.isNotEmpty ?
  Container(
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  mainAxisAlignment: MainAxisAlignment.start,
  children: [
  Padding(
  padding: const EdgeInsets.symmetric(
  vertical: 10.0, horizontal: 5),
  child: Text("I’m asking ${employerController.text} to start providing for me:",
  style: GoogleFonts.lato(
  textStyle: Theme
      .of(context)
      .textTheme
      .titleMedium
  )),
  ),
  Consumer<PreviewProvider>(
  builder: (context, previewProvider, _) {
  return Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: previewProvider.PreviewSolutionMustHave.map((solution) {
  return Padding(
  padding: EdgeInsets.only(bottom: 20.0),
  child: Row(
  children: [
  Flexible(
  child: RichText(
  maxLines: 2,
  overflow: TextOverflow.ellipsis,
  text: TextSpan(
  children: [
  TextSpan(
  text: ' •  ',
  style: TextStyle(fontSize: 20)
  ),
  TextSpan(
  text: '${solution['Label']}',
  style: GoogleFonts.lato(textStyle: Theme
      .of(context)
      .textTheme
      .titleMedium,fontWeight: FontWeight.bold,)
  ),
  TextSpan(
  text: ' - ${solution['Final_description']}\n',
  style: GoogleFonts.lato(textStyle: Theme
      .of(context)
      .textTheme
      .bodyMedium,fontWeight: FontWeight.w400
  )
  ),
  TextSpan(
  text: '  ${solution['AboutMe_Notes']}',
  style: GoogleFonts.lato(textStyle: Theme
      .of(context)
      .textTheme
      .titleMedium,color: Colors.grey,)
  ),
  ],
  ),
  ),
  ),
  SizedBox(width: 50,),
  Row(
  children: [
  IconButton(
  icon: Icon(Icons.edit),
  onPressed: (){
  showEditconfirmSolutionsDialogBox(solution['id'], solution['Label'] , solution['Description'],
  solution['Source'], solution['Challenge Status'], solution['tags'], solution['Created By'],
  solution['Created Date'], solution['Modified By'], solution['Modified Date'],
  solution['Original Description'], solution['Impact'], solution['Final_description'],
  solution['Category'], solution['Keywords'], solution['Potential Strengths'],
  solution['Hidden Strengths'],solution, solution['AboutMe_Notes'],solution['Provider'],solution['InPlace']);
  },
  ),
  IconButton(
  icon: Icon(Icons.delete),
  onPressed: (){
  _userAboutMEProvider.removeEditConfirmSolution(solution["id"],solutionsList,
  _previewProvider.PreviewSolutionMyResposibilty,
  _previewProvider.PreviewSolutionStillNeeded,
  _previewProvider.PreviewSolutionNotNeededAnyMore,
  _previewProvider.PreviewSolutionNiceToHave,
  _previewProvider.PreviewSolutionMustHave,
  );
  },
  )
  ],
  )
  ],
  ),
  );
  }).toList(),
  );
  },
  ),
  ],
  ),
  ) : Container(),

  _previewProvider.PreviewSolutionNiceToHave.isNotEmpty ?
  Container(
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  mainAxisAlignment: MainAxisAlignment.start,
  children: [
  Padding(
  padding: const EdgeInsets.symmetric(
  vertical: 10.0, horizontal: 5),
  child: Text("I’m asking  ${employerController.text} to start providing for me but they are not essential: ",
  style: GoogleFonts.lato(
  textStyle: Theme
      .of(context)
      .textTheme
      .titleMedium
  )),
  ),
  Consumer<PreviewProvider>(
  builder: (context, previewProvider, _) {
  return Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: previewProvider.PreviewSolutionNiceToHave.map((solution) {
  return Padding(
  padding: EdgeInsets.only(bottom: 20.0),
  child: Row(
  children: [
  Flexible(
  child: RichText(
  maxLines: 2,
  overflow: TextOverflow.ellipsis,
  text: TextSpan(
  children: [
  TextSpan(
  text: ' •  ',
  style: TextStyle(fontSize: 20)
  ),
  TextSpan(
  text: '${solution['Label']}',
  style: GoogleFonts.lato(textStyle: Theme
      .of(context)
      .textTheme
      .titleMedium,fontWeight: FontWeight.bold,)
  ),
  TextSpan(
  text: ' - ${solution['Final_description']}\n',
  style: GoogleFonts.lato(textStyle: Theme
      .of(context)
      .textTheme
      .bodyMedium,fontWeight: FontWeight.w400
  )
  ),
  TextSpan(
  text: '  ${solution['AboutMe_Notes']}',
  style: GoogleFonts.lato(textStyle: Theme
      .of(context)
      .textTheme
      .titleMedium,color: Colors.grey,)
  ),
  ],
  ),
  ),
  ),
  SizedBox(width: 50,),
  Row(
  children: [
  IconButton(
  icon: Icon(Icons.edit),
  onPressed: (){
  showEditconfirmSolutionsDialogBox(solution['id'], solution['Label'] , solution['Description'],
  solution['Source'], solution['Challenge Status'], solution['tags'], solution['Created By'],
  solution['Created Date'], solution['Modified By'], solution['Modified Date'],
  solution['Original Description'], solution['Impact'], solution['Final_description'],
  solution['Category'], solution['Keywords'], solution['Potential Strengths'],
  solution['Hidden Strengths'], solution, solution['AboutMe_Notes'],solution['Provider'],solution['InPlace']);
  },
  ),
  IconButton(
  icon: Icon(Icons.delete),
  onPressed: (){
  _userAboutMEProvider.removeEditConfirmSolution(solution["id"],solutionsList,
  _previewProvider.PreviewSolutionMyResposibilty,
  _previewProvider.PreviewSolutionStillNeeded,
  _previewProvider.PreviewSolutionNotNeededAnyMore,
  _previewProvider.PreviewSolutionNiceToHave,
  _previewProvider.PreviewSolutionMustHave,
  );
  },
  )
  ],
  )
  ],
  ),
  );
  }).toList(),
  );
  },
  ),
  ],
  ),
  ) : Container(),

  _previewProvider.PreviewSolutionNotNeededAnyMore .isNotEmpty ?
  Container(
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  mainAxisAlignment: MainAxisAlignment.start,
  children: [
  Padding(
  padding: const EdgeInsets.symmetric(
  vertical: 10.0, horizontal: 5),
  child: Text("${employerController.text} already provides for me but are not needed anymore: ",
  style: GoogleFonts.lato(
  textStyle: Theme
      .of(context)
      .textTheme
      .titleMedium
  )),
  ),
  Consumer<PreviewProvider>(
  builder: (context, previewProvider, _) {
  return Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: previewProvider.PreviewSolutionNotNeededAnyMore.map((solution) {
  return Padding(
  padding: EdgeInsets.only(bottom: 20.0),
  child: Row(
  children: [
  Flexible(
  child: RichText(
  maxLines: 2,
  overflow: TextOverflow.ellipsis,
  text: TextSpan(
  children: [
  TextSpan(
  text: ' •  ',
  style: TextStyle(fontSize: 20)
  ),
  TextSpan(
  text: '${solution['Label']}',
  style: GoogleFonts.lato(textStyle: Theme
      .of(context)
      .textTheme
      .titleMedium,fontWeight: FontWeight.bold,)
  ),
  TextSpan(
  text: ' - ${solution['Final_description']}\n',
  style: GoogleFonts.lato(textStyle: Theme
      .of(context)
      .textTheme
      .bodyMedium,fontWeight: FontWeight.w400
  )
  ),
  TextSpan(
  text: '  ${solution['AboutMe_Notes']}',
  style: GoogleFonts.lato(textStyle: Theme
      .of(context)
      .textTheme
      .titleMedium,color: Colors.grey,)
  ),
  ],
  ),
  ),
  ),
  SizedBox(width: 50,),
  Row(
  children: [
  IconButton(
  icon: Icon(Icons.edit),
  onPressed: (){
  showEditconfirmSolutionsDialogBox(solution['id'], solution['Label'] , solution['Description'],
  solution['Source'], solution['Challenge Status'], solution['tags'], solution['Created By'],
  solution['Created Date'], solution['Modified By'], solution['Modified Date'],
  solution['Original Description'], solution['Impact'], solution['Final_description'],
  solution['Category'], solution['Keywords'], solution['Potential Strengths'],
  solution['Hidden Strengths'], solution, solution['AboutMe_Notes'],solution['Provider'],solution['InPlace']);
  },
  ),
  IconButton(
  icon: Icon(Icons.delete),
  onPressed: (){
  _userAboutMEProvider.removeEditConfirmSolution(solution["id"],solutionsList,
  _previewProvider.PreviewSolutionMyResposibilty,
  _previewProvider.PreviewSolutionStillNeeded,
  _previewProvider.PreviewSolutionNotNeededAnyMore,
  _previewProvider.PreviewSolutionNiceToHave,
  _previewProvider.PreviewSolutionMustHave,
  );
  },
  )
  ],
  )
  ],
  ),
  );
  }).toList(),
  );
  },
  ),
  ],
  ),
  ) : Container(),

  SizedBox(height: 5,),
  ],
  ),
  ),

  Padding(
  padding: const EdgeInsets.symmetric(
  vertical: 15.0, horizontal: 5),
  child: TextField(
  controller: AboutMeUseFulInfotextController,
  onChanged: (value) {
  _previewProvider.updatetitle(value);
  },
  style: GoogleFonts.lato(
  textStyle: Theme.of(context).textTheme.bodySmall,
  fontWeight: FontWeight.w400,
  color: Colors.black),
  decoration: InputDecoration(
  hintText: "Links/Document/Product Info",
  focusedBorder: OutlineInputBorder(
  borderSide: BorderSide(color: Colors.black),
  borderRadius: BorderRadius.circular(10)),
  border: OutlineInputBorder(
  borderSide: BorderSide(color: Colors.black12),
  borderRadius: BorderRadius.circular(10)),
  ),
  ),
  ),

  Row(
  children: [
  Padding(
  padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5),
  child: Text("Attachments :", style: GoogleFonts.lato(textStyle: Theme.of(context).textTheme.titleSmall,)),
  ),
  SizedBox(width: 10,),

  // InkWell(
  //   onTap: (){
  //     // _userAboutMEProvider.pickFiles();
  //   },
  //   child: Container(
  //     // padding: EdgeInsets.all(20),
  //     child: Center(child: Icon(Icons.add, size: 30, color: Colors.white,)),
  //     width: 30,
  //     height: 30,
  //     decoration: BoxDecoration(
  //       color: Colors.blue,
  //       borderRadius: BorderRadius.circular(50),
  //     ),
  //   ),
  // ),
  IconButton(onPressed: (){},
  icon: Container(
  // padding: EdgeInsets.all(20),
  child: Center(child: Icon(Icons.add, size: 30, color: Colors.white,)),
  width: 30,
  height: 30,
  decoration: BoxDecoration(
  color: Colors.blue,
  borderRadius: BorderRadius.circular(50),
  ),
  ),
  tooltip: "Medicals and Personals",
  ),
  ],
  ),
  Padding(
  padding: const EdgeInsets.all(8.0),
  child: Text("${_userAboutMEProvider.aadhar==null ? "" : _userAboutMEProvider.aadhar}", style: GoogleFonts.lato(textStyle: Theme.of(context).textTheme.titleSmall,)),
  // child: Text("document.pdf", style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.titleSmall,)),
  ),

  // Row(
  //   mainAxisSize: MainAxisSize.min,
  //   mainAxisAlignment: MainAxisAlignment.start,
  //   // crossAxisAlignment: CrossAxisAlignment.start,
  //   children: [
  //
  //     Container(
  //       width: MediaQuery.of(context).size.width * .12,
  //       child: Text("Report file name:   ", style: GoogleFonts.lato(
  //           textStyle: Theme.of(context).textTheme.titleMedium,
  //           fontStyle: FontStyle.italic,
  //           fontWeight: FontWeight.bold
  //       )),
  //     ),
  //
  //     Flexible(
  //       child: Container(
  //         height: 40,
  //         width: MediaQuery.of(context).size.width * .25,
  //         child: TextField(
  //           controller: AboutMeLabeltextController,
  //           onChanged: (value) {
  //             _previewProvider.updatetitle(value);
  //           },
  //           style: GoogleFonts.lato(
  //               textStyle: Theme.of(context).textTheme.bodySmall,
  //               fontStyle: FontStyle.italic,
  //               fontWeight: FontWeight.w400,
  //               color: Colors.black),
  //           decoration: InputDecoration(
  //             hintText: "My discussion with ...." ,
  //             focusedBorder: OutlineInputBorder(
  //                 borderSide: BorderSide(color: Colors.black),
  //                 borderRadius: BorderRadius.circular(10)),
  //             border: OutlineInputBorder(
  //                 borderSide: BorderSide(color: Colors.black12),
  //                 borderRadius: BorderRadius.circular(10)),
  //           ),
  //         ),
  //       ),
  //     ),
  //
  //     // SizedBox(width: 10,),
  //     //
  //     // InkWell(
  //     //   onTap: () async {
  //     //     // sideMenu.changePage(2);
  //     //     // page.jumpToPage(1);
  //     //   },
  //     //   child: Container(
  //     //     // margin: EdgeInsets.all(10),
  //     //     padding: EdgeInsets.all(5),
  //     //     height: 40,
  //     //     width: MediaQuery.of(context).size.width * 0.15,
  //     //     decoration: BoxDecoration(
  //     //       // color: Colors.white,
  //     //       border: Border.all(color:primaryColorOfApp, width: 1.0),
  //     //       borderRadius: BorderRadius.circular(10.0),
  //     //     ),
  //     //     child: Row(
  //     //       mainAxisAlignment: MainAxisAlignment.center,
  //     //       crossAxisAlignment: CrossAxisAlignment.center,
  //     //       children: [
  //     //         Icon(Icons.insert_drive_file,color: Colors.black,size: 20,),
  //     //         SizedBox(width: 5,),
  //     //         Expanded(
  //     //           child: Text(
  //     //             // 'Thrivers',
  //     //             'For Someone Else',
  //     //             overflow: TextOverflow.ellipsis,
  //     //             style: GoogleFonts.montserrat(
  //     //                 textStyle:
  //     //                 Theme.of(context).textTheme.bodySmall,
  //     //                 color: Colors.black),
  //     //           ),
  //     //         ),
  //     //       ],
  //     //     ),
  //     //   ),
  //     //
  //     // ),
  //
  //   ],
  // ),

  SizedBox(height: 10,),

  Padding(
  padding: const EdgeInsets.only(left: 20.0),
  child: Row(
  mainAxisAlignment: MainAxisAlignment.end,
  children: [

  InkWell(
  onTap: () async {

  var createdAt = DateFormat('yyyy-MM-dd, hh:mm').format(DateTime.now());

  Map<String, dynamic> AboutMEDatas = {
  'About_Me_Label': AboutMeLabeltextController.text,
  'Purpose_of_report': _previewProvider.PurposeOfReporttextController.text,
  'Purpose': _previewProvider.isOfficial,
  'AB_Description' : AboutMeDescriptiontextController.text,
  'AB_Date' : AboutMeDatetextController.text,
  'AB_Useful_Info' : AboutMeUseFulInfotextController.text,
  'AB_Attachment' : "",
  'Solutions': solutionsList,
  'Challenges': challengesList,
  };

  String solutionJson = json.encode(AboutMEDatas);
  print("About_Me_Label: ${AboutMEDatas['About_Me_Label']}");

  ProgressDialog.show(context, "Completing", Icons.save);
  await ApiRepository().updateAboutMe(AboutMEDatas,documentId);

  // downloadAboutMePdf(challengesList,solutionsList);

  widget.refreshPage();

  ProgressDialog.hide();

  // sendMailPopUp(challengesList,solutionsList);

  // selectedEmail = null;
  // nameController.clear();
  // searchEmailcontroller.clear();
  // employerController.clear();
  // divisionOrSectionController.clear();
  // RoleController.clear();
  // LocationController.clear();
  // EmployeeNumberController.clear();
  // LineManagerController.clear();
  // mycircumstancesController.clear();
  // MystrengthsController.clear();
  // mycircumstancesController.clear();
  // AboutMeLabeltextController.clear();
  // RefineController.clear();
  // solutionsList.clear();
  // _userAboutMEProvider.solutionss.clear();
  // _userAboutMEProvider.challengess.clear();
  // _userAboutMEProvider.combinedSolutionsResults.clear();
  // _userAboutMEProvider.combinedResults.clear();
  // previewProvider.email=null;
  // previewProvider.name=null;
  // previewProvider.employer=null;
  // previewProvider.division=null;
  // previewProvider.role=null;
  // previewProvider.location=null;
  // previewProvider.employeeNumber=null ;
  // previewProvider.linemanager=null;
  // previewProvider.title=null;
  // previewProvider.mycircumstance=null;
  // previewProvider.mystrength=null ;
  // previewProvider.myorganization=null ;
  // previewProvider.mychallenge=null ;
  // previewProvider.PreviewChallengesList.clear();
  // previewProvider.PreviewSolutionList.clear();
  // // _navigateToTab(0);
  // // Navigator.pop(context);
  // setState(() {
  //   page.jumpToPage(1);
  // });

  },
  child:Container(
  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
  width: MediaQuery.of(context).size.width * .15,
  decoration: BoxDecoration(
  color:Colors.blue ,
  border: Border.all(
  color:Colors.blue ,
  width: 1.0),
  borderRadius: BorderRadius.circular(15.0),
  ),
  child: Center(
  child:Text(
  'Save',
  style: GoogleFonts.montserrat(
  textStyle:
  Theme
      .of(context)
      .textTheme
      .titleSmall,
  fontWeight: FontWeight.bold,
  color:Colors.white ,
  ),
  ),
  ),
  ),
  ),
  SizedBox(width: 10,),

  InkWell(
  onTap: () async {

  var createdAt = DateFormat('yyyy-MM-dd, hh:mm').format(DateTime.now());

  var formattedDate = DateFormat('dd MMMM yyyy, HH:mm a').format(DateTime.now());


  Map<String, dynamic> AboutMEDatas = {
  'About_Me_Label': AboutMeLabeltextController.text,
  'AB_Status' : "Complete and Sent",
  'AB_Description' : AboutMeDescriptiontextController.text,
  'AB_Useful_Info' : AboutMeUseFulInfotextController.text,
  'Purpose_of_report': _previewProvider.PurposeOfReporttextController.text,
  'Purpose': _previewProvider.isOfficial,
  'AB_Date' : AboutMeDatetextController.text,
  'AB_Attachment' : "",
  'Solutions': solutionsList,
  'Challenges': challengesList,
  'Report_sent_to' : [{'name':  previewProvider.SendNametextController.text, 'email': SendEmailtextController.text, 'datetime': formattedDate}],
  'Report_sent_to_cc' : List.generate(
  previewProvider.ccEmails.length,
  (index) => {
  'name': previewProvider.ccNames[index],
  'email': previewProvider.ccEmails[index],
  'datetime': formattedDate, // Format datetime
  },
  ),

  };

  String solutionJson = json.encode(AboutMEDatas);
  print(solutionJson);

  ProgressDialog.show(context, "Completing", Icons.save);
  await ApiRepository().updateAboutMe(AboutMEDatas,documentId);

  final Uint8List pdfBytes = await makePdf(challengesList,solutionsList);
  String base64EncodedData = base64.encode(pdfBytes);
  String filename = "${About_Me_Label}.pdf";
  print("sendMailPopUp chunks: ${base64EncodedData}");
  print("sendMailPopUp filename: ${ filename}");
  await ApiRepository().sendEmailWithAttachment(
  context,
  SendEmailtextController.text,
  previewProvider.SendNametextController.text,
  CopySendEmailtextController.text,
  CopySendNametextController.text,
  base64EncodedData,
  filename,
  ccEmails: previewProvider.ccEmails,
  ccNames: previewProvider.ccNames,
  );

  await downloadAboutMePdf(challengesList,solutionsList);

  print(SendEmailtextController.text);
  print(CopySendEmailtextController.text);
  print(previewProvider.SendNametextController.text);
  print(CopySendNametextController.text);


  setState(() {
  Navigator.pop(context);
  });

  ProgressDialog.hide();

  // sendMailPopUp(challengesList,solutionsList);

  // downloadAboutMePdf(challengesList,solutionsList);
  ///
  // selectedEmail = null;
  // nameController.clear();
  // searchEmailcontroller.clear();
  // employerController.clear();
  // divisionOrSectionController.clear();
  // RoleController.clear();
  // LocationController.clear();
  // EmployeeNumberController.clear();
  // LineManagerController.clear();
  // mycircumstancesController.clear();
  // MystrengthsController.clear();
  // mycircumstancesController.clear();
  // AboutMeLabeltextController.clear();
  // RefineController.clear();
  // solutionsList.clear();
  // _userAboutMEProvider.solutionss.clear();
  // _userAboutMEProvider.challengess.clear();
  // _userAboutMEProvider.combinedSolutionsResults.clear();
  // _userAboutMEProvider.combinedResults.clear();
  // previewProvider.email=null;
  // previewProvider.name=null;
  // previewProvider.employer=null;
  // previewProvider.division=null;
  // previewProvider.role=null;
  // previewProvider.location=null;
  // previewProvider.employeeNumber=null ;
  // previewProvider.linemanager=null;
  // previewProvider.title=null;
  // previewProvider.mycircumstance=null;
  // previewProvider.mystrength=null ;
  // previewProvider.myorganization=null ;
  // previewProvider.mychallenge=null ;
  // previewProvider.PreviewChallengesList.clear();
  // previewProvider.PreviewSolutionList.clear();
  // // _navigateToTab(0);
  // // Navigator.pop(context);
  // setState(() {
  //   page.jumpToPage(1);
  // });

  },
  child:Container(
  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
  width: MediaQuery.of(context).size.width * .15,
  decoration: BoxDecoration(
  color:Colors.blue ,
  border: Border.all(
  color:Colors.blue ,
  width: 1.0),
  borderRadius: BorderRadius.circular(15.0),
  ),
  child: Center(
  child:Text(
  'Complete and Send',
  style: GoogleFonts.montserrat(
  textStyle:
  Theme
      .of(context)
      .textTheme
      .titleSmall,
  fontWeight: FontWeight.bold,
  color:Colors.white ,
  ),
  ),
  ),
  ),
  )
  ],
  ),
  )

  ],
  ),
  ),
  );
  });
  }

}