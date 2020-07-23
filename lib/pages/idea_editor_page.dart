import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:my_idea_pool/models/app_idea.dart';
import 'package:my_idea_pool/shared/common_utils.dart';

class IdeaEditorPage extends StatefulWidget {
  final Function add;
  final Function update;
  final AppIdea appIdea;

  IdeaEditorPage({Key key, this.add, this.update, this.appIdea})
      : super(
            key: key ??
                ValueKey(appIdea != null
                    ? 'IdeaEditorPage_${appIdea.id}'
                    : 'IdeaEditorPage_new'));

  @override
  _IdeaEditorPageState createState() => _IdeaEditorPageState();
}

class _IdeaEditorPageState extends State<IdeaEditorPage> {
  double _average = 10;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext buildContext) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        leading: Icon(
          Icons.lightbulb_outline,
          color: Colors.white,
        ),
      ),
      body: Container(
        child: _ideaEditorForm(buildContext),
      ),
    );
  }

  final GlobalKey<FormBuilderState> _ideaEditorFormKey =
      GlobalKey<FormBuilderState>();
  final _dropdownItems = ['10', '9', '8', '7', '6', '5', '4', '3', '2', '1'];
  _updateAverage(Map<String, dynamic> currentValues) {
    int sum = 0;
    currentValues.forEach((key, value) {
      if (["impact", "ease", "confidence"].contains(key)) {
        sum += int.parse(value);
      }
    });
    if (sum > 0) {
      setState(() {
        _average = sum / 3;
      });
    }
  }

  _ideaEditorForm(BuildContext buildContext) {
    return ListView(
      children: <Widget>[
        FormBuilder(
          key: _ideaEditorFormKey,
          child: Column(
            children: <Widget>[
              FormBuilderTextField(
                attribute: "content",
                decoration: InputDecoration(labelText: "Idea"),
                validators: [
                  FormBuilderValidators.required(),
                  FormBuilderValidators.max(255),
                ],
              ),
              FormBuilderDropdown(
                attribute: "impact",
                decoration: InputDecoration(labelText: "Impact"),
                initialValue: '10',
                //validators: [FormBuilderValidators.required()],
                onChanged: (val) {
                  _ideaEditorFormKey.currentState.save();
                  _updateAverage(_ideaEditorFormKey.currentState.value);
                },
                items: _dropdownItems
                    .map((num) =>
                        DropdownMenuItem(value: num, child: Text("$num")))
                    .toList(),
              ),
              FormBuilderDropdown(
                attribute: "ease",
                decoration: InputDecoration(labelText: "Ease"),
                initialValue: '10',
                //validators: [FormBuilderValidators.required()],
                onChanged: (val) {
                  _ideaEditorFormKey.currentState.save();
                  _updateAverage(_ideaEditorFormKey.currentState.value);
                },
                items: _dropdownItems
                    .map((num) =>
                        DropdownMenuItem(value: num, child: Text("$num")))
                    .toList(),
              ),
              FormBuilderDropdown(
                attribute: "confidence",
                decoration: InputDecoration(labelText: "Confidence"),
                initialValue: '10',
                //validators: [FormBuilderValidators.required()],
                onChanged: (val) {
                  _ideaEditorFormKey.currentState.save();
                  _updateAverage(_ideaEditorFormKey.currentState.value);
                },
                items: _dropdownItems
                    .map((num) =>
                        DropdownMenuItem(value: num, child: Text("$num")))
                    .toList(),
              ),
              FormBuilderTextField(
                attribute: "average",
                decoration: InputDecoration(labelText: "Avg."),
                initialValue: _average.truncate().toString(),
                readOnly: true,
              ),
            ],
          ),
        ),
        SizedBox(
          width: 20,
          height: 20,
        ),
        MaterialButton(
          color: Colors.green,
          child: Text(
            'SAVE',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            if (_ideaEditorFormKey.currentState.saveAndValidate()) {
              CommonUtils.logger.d(_ideaEditorFormKey.currentState.value);

              widget.add(_ideaEditorFormKey.currentState.value);
              Navigator.pop(buildContext);
            } else {
              CommonUtils.logger.d(_ideaEditorFormKey.currentState.value);
              CommonUtils.logger.d('validation failed');
            }
          },
        ),
        MaterialButton(
          child: Text(
            "CANCEL",
            style: TextStyle(color: Colors.white),
          ),
          color: Colors.grey.withAlpha(66),
          onPressed: () {
            _ideaEditorFormKey.currentState.reset();
            Navigator.pop(buildContext);
          },
        ),
      ],
    );
  }
}
