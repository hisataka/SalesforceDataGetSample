#!/usr/bin/env perl

use strict;
use WWW::Salesforce;
use Data::Dumper;

# ログイン
my $user = 'xxxxxx';
my $pass = 'xxxxxx';
my $sfurl = 'https://www.salesforce.com/services/Soap/u/23.0';
my $sf = WWW::Salesforce->login(
	username => $user
	, password => $pass
    , serverurl => $sfurl
);

# 検索
my $query = 'Select Owner.Username, Owner.Name, Id, WhoId, WhatId, Subject, Location, IsAllDayEvent, ActivityDateTime, ActivityDate, DurationInMinutes
                , StartDateTime, EndDateTime, Description, AccountId, OwnerId, IsPrivate, ShowAs, IsDeleted, IsChild, IsGroupEvent
                , GroupEventType, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, IsArchived, RecurrenceActivityId
                , IsRecurrence, RecurrenceStartDateTime, RecurrenceEndDateOnly, RecurrenceTimeZoneSidKey, RecurrenceType, RecurrenceInterval
                , RecurrenceDayOfWeekMask, RecurrenceDayOfMonth, RecurrenceInstance, RecurrenceMonthOfYear, ReminderDateTime, IsReminderSet
                , (Select Attendee.Username, Attendee.Name, Id, EventId, AttendeeId, Status, RespondedDate, Response, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById
                    , SystemModstamp, IsDeleted
                   FROM EventAttendees)
             FROM Event';
my $result = $sf->query(
    query => $query
);

               
#検索結果の処理
my @out = outSObject($result->valueof('//queryResponse/result/records'));
for my $line (@out) {
    print(Encode::encode('euc-jp', $line) . "\n");
}

sub makeHeader{
    my $delimiter = shift;
    my $line = 'Owner.Username' . $delimiter . 'Owner.Name' . $delimiter . 'Event.ID' . $delimiter . 'Event.WHOID' . $delimiter . 'Event.WHATID' . $delimiter . 'Event.SUBJECT' . $delimiter . 'Event.LOCATION' . $delimiter . 'Event.ISALLDAYEVENT' . $delimiter . 'Event.ACTIVITYDATETIME' . $delimiter . 'Event.ACTIVITYDATE' . $delimiter . 'Event.DURATIONINMINUTES' . $delimiter . 'Event.STARTDATETIME' . $delimiter . 'Event.ENDDATETIME' . $delimiter . 'Event.DESCRIPTION' . $delimiter . 'Event.ACCOUNTID' . $delimiter . 'Event.OWNERID' . $delimiter . 'Event.ISPRIVATE' . $delimiter . 'Event.SHOWAS' . $delimiter . 'Event.ISDELETED' . $delimiter . 'Event.ISCHILD' . $delimiter . 'Event.ISGROUPEVENT' . $delimiter . 'Event.GROUPEVENTTYPE' . $delimiter . 'Event.CREATEDDATE' . $delimiter . 'Event.CREATEDBYID' . $delimiter . 'Event.LASTMODIFIEDDATE' . $delimiter . 'Event.LASTMODIFIEDBYID' . $delimiter . 'Event.SYSTEMMODSTAMP' . $delimiter . 'Event.ISARCHIVED' . $delimiter . 'Event.RECURRENCEACTIVITYID' . $delimiter . 'Event.ISRECURRENCE' . $delimiter . 'Event.RECURRENCESTARTDATETIME' . $delimiter . 'Event.RECURRENCEENDDATEONLY' . $delimiter . 'Event.RECURRENCETIMEZONESIDKEY' . $delimiter . 'Event.RECURRENCETYPE' . $delimiter . 'Event.RECURRENCEINTERVAL' . $delimiter . 'Event.RECURRENCEDAYOFWEEKMASK' . $delimiter . 'Event.RECURRENCEDAYOFMONTH' . $delimiter . 'Event.RECURRENCEINSTANCE' . $delimiter . 'Event.RECURRENCEMONTHOFYEAR' . $delimiter . 'Event.REMINDERDATETIME' . $delimiter . 'Event.ISREMINDERSET'
            . 'Attendee.Username' . $delimiter . 'Attendee.Name' . $delimiter . 'EventAttendee.ID' . $delimiter . 'EventAttendee.EVENTID' . $delimiter . 'EventAttendee.ATTENDEEID' . $delimiter . 'EventAttendee.STATUS' . $delimiter . 'EventAttendee.RESPONDEDDATE' . $delimiter . 'EventAttendee.RESPONSE' . $delimiter . 'EventAttendee.CREATEDDATE' . $delimiter . 'EventAttendee.CREATEDBYID' . $delimiter . 'EventAttendee.LASTMODIFIEDDATE' . $delimiter . 'EventAttendee.LASTMODIFIEDBYID' . $delimiter . 'EventAttendee.SYSTEMMODSTAMP' . $delimiter . 'EventAttendee.ISDELETED';
    return $line;
}
sub makeParent{
    my($rec, $delimiter) = @_;
    my $line = $rec->{Owner}->{Username} . $delimiter . $rec->{Owner}->{Name} . $delimiter . 
        $rec->{Id} . $delimiter . $rec->{WhoId} . $delimiter . $rec->{WhatId} . $delimiter . $rec->{Subject} . $delimiter . $rec->{Location} . $delimiter . 
        $rec->{IsAllDayEvent} . $delimiter . $rec->{ActivityDateTime} . $delimiter . $rec->{ActivityDate} . $delimiter . $rec->{DurationInMinutes} . $delimiter . 
        $rec->{StartDateTime} . $delimiter . $rec->{EndDateTime} . $delimiter . $rec->{Description} . $delimiter . $rec->{AccountId} . $delimiter . 
        $rec->{OwnerId} . $delimiter . $rec->{IsPrivate} . $delimiter . $rec->{ShowAs} . $delimiter . $rec->{IsDeleted} . $delimiter . $rec->{IsChild} . $delimiter . 
        $rec->{IsGroupEvent} . $delimiter . $rec->{GroupEventType} . $delimiter . $rec->{CreatedDate} . $delimiter . $rec->{CreatedById} . $delimiter . 
        $rec->{LastModifiedDate} . $delimiter . $rec->{LastModifiedById} . $delimiter . $rec->{SystemModstamp} . $delimiter . $rec->{IsArchived} . $delimiter . 
        $rec->{RecurrenceActivityId} . $delimiter . $rec->{IsRecurrence} . $delimiter . $rec->{RecurrenceStartDateTime} . $delimiter . $rec->{RecurrenceEndDateOnly} . $delimiter . 
        $rec->{RecurrenceTimeZoneSidKey} . $delimiter . $rec->{RecurrenceType} . $delimiter . $rec->{RecurrenceInterval} . $delimiter . $rec->{RecurrenceDayOfWeekMask} . $delimiter . 
        $rec->{RecurrenceDayOfMonth} . $delimiter . $rec->{RecurrenceInstance} . $delimiter . $rec->{RecurrenceMonthOfYear} . $delimiter . $rec->{ReminderDateTime} . $delimiter . $rec->{IsReminderSet};
    return $line;
}
sub makeChild{
    my($rec, $delimiter) = @_;
    my $line = $rec->{Attendee}->{Username} . $delimiter . $rec->{Attendee}->{Name} . $delimiter . 
        $rec->{Id} . $delimiter . $rec->{EventId} . $delimiter . $rec->{AttendeeId} . $delimiter . $rec->{Status} . $delimiter . $rec->{RespondedDate} . $delimiter . 
        $rec->{Response} . $delimiter . $rec->{CreatedDate} . $delimiter . $rec->{CreatedById} . $delimiter . $rec->{LastModifiedDate} . $delimiter . $rec->{LastModifiedById} . $delimiter . 
        $rec->{SystemModstamp} . $delimiter . $rec->{IsDeleted};
    return $line;
}
sub outSObject{
    my @result = @_;
    my @lines = ();
    #ヘッダーを作成
    push(@lines,makeHeader("\t"));

    for my $parentRec (@result) {
        #子（EventAttendee）が存在すれば親＋子で作成
        if($parentRec->{EventAttendees}->{records}) {
            #子が複数紐付く場合は、子レコード分だけ親＋子を作成
            if(ref($parentRec->{EventAttendees}->{records}) eq 'ARRAY') {
                for(my $i = 0; $i < $parentRec->{EventAttendees}->{size}; $i ++) {
                    my $line = makeParent($parentRec, "\t");
                    my $childRec = $parentRec->{EventAttendees}->{records}[$i];
                    $line = $line . "\t" . makeChild($childRec, "\t");
                    push(@lines, $line);
                }
            }
            #子が一つの場合は、単一で親＋子を作成
            else {
                my $line = makeParent($parentRec, "\t");
                my $childRec = $parentRec->{EventAttendees}->{records};
                $line = $line . "\t" . makeChild($childRec, "\t");
                push(@lines, $line);
            }
        }
        # 子がない場合は、親のみで作成
        else {
            #親（Event）を処理
            my $line = makeParent($parentRec, "\t");
            push(@lines, $line);
        }
    }
    return @lines;
}
