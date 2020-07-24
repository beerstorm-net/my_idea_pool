import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../blocs/auth/auth_bloc.dart';
import '../models/app_idea.dart';
import '../shared/common_utils.dart';
import '../widgets/common_dialogs.dart';

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
        //leading: appBarLeading()
        title: appBarLeading(),
        centerTitle: false,
      ),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(33.0),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              FormBuilderTextField(
                attribute: "content",
                decoration: InputDecoration(labelText: "Idea"),
                initialValue:
                    widget.appIdea != null ? widget.appIdea.content : '',
                validators: [
                  FormBuilderValidators.required(),
                  FormBuilderValidators.max(255),
                ],
              ),
              FormBuilderDropdown(
                attribute: "impact",
                decoration: InputDecoration(labelText: "Impact"),
                initialValue:
                    widget.appIdea != null ? widget.appIdea.impact : '10',
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
                initialValue:
                    widget.appIdea != null ? widget.appIdea.ease : '10',
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
                initialValue:
                    widget.appIdea != null ? widget.appIdea.confidence : '10',
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
              SizedBox(
                width: 20,
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Avg. ',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    widget.appIdea != null
                        ? widget.appIdea.average_score.toStringAsFixed(1)
                        : _average.toStringAsFixed(1),
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              Divider(
                thickness: 2.0,
              ),
              /*FormBuilderTextField(
                attribute: "average",
                decoration: InputDecoration(labelText: "Avg."),
                initialValue: widget.appIdea != null
                    ? widget.appIdea.average_score.toStringAsFixed(1)
                    : _average.toString(),
                readOnly: true,
              ),*/
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

              BlocProvider.of<AuthBloc>(context).add(WarnUserEvent(
                  List<String>()..add("progress_start"),
                  message: ""));

              if (widget.update != null && widget.appIdea != null) {
                widget.update(_ideaEditorFormKey.currentState.value,
                    appIdea: widget.appIdea);
              } else {
                widget.add(_ideaEditorFormKey.currentState.value);
              }
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
