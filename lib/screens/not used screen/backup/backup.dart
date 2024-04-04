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

}