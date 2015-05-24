# CodeBook, analyzed.txt file.
The data in this file resresents means (grouped by Subject and Activity), of the means or standard deviations of the corresponding rows in the files in the Inertial Signals directory.
Columns 1-2 represent the group, i.e., the Subject and Activity.  Each of the remaining 
columns in the row represents a mean for this subject and activity of mean or std deviation (by rows) in the corresponding file.  Each row therefore in a sense represents an observation of summary data for a single (Subject + Activity) pair.
<table>
<tr><th>Name</th><th>Data Type</th><th>Description</th></tr>
<tr>
	<td>Subject</td>
	<td>(Integer)</td>
	<td>Numbered Test Subject, 1-30</td>
</tr>
<tr>
	<td>Activity</td>
	<td>(Factor)</td>
	<td>Activity label, one of WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING</td>
</tr>
<tr>
	<td>mean_body_acc_x </td>
	<td>(Numeric)</td>
	<td>Mean of the row means from the file body_acc_x_merged.txt</td>
</tr>
<tr>
	<td>stddev_body_acc_x </td>
	<td>(Numeric)</td>
	<td>Mean of the row standard deviations from the file body_acc_x_merged.txt</td>
</tr>
<tr>
	<td>mean_body_acc_y </td>
	<td>(Numeric)</td>
	<td>Mean of the row means from the file body_acc_y_merged.txt</td>
</tr>
<tr>
	<td>stddev_body_acc_y </td>
	<td>(Numeric)</td>
	<td>Mean of the row standard deviations from the file body_acc_y_merged.txt</td>
</tr>
<tr>
	<td>mean_body_acc_z </td>
	<td>(Numeric)</td>
	<td>Mean of the row means from the file body_acc_z_merged.txt</td>
</tr>
<tr>
	<td>stddev_body_acc_z </td>
	<td>(Numeric)</td>
	<td>Mean of the row standard deviations from the file body_acc_z_merged.txt</td>
</tr>
<tr>
	<td>mean_body_gyro_x </td>
	<td>(Numeric)</td>
	<td>Mean of the row means from the file body_gyro_x_merged.txt</td>
</tr>
<tr>
	<td>stddev_body_gyro_x </td>
	<td>(Numeric)</td>
	<td>Mean of the row standard deviations from the file body_gyro_x_merged.txt</td>
</tr>
<tr>
	<td>mean_body_gyro_y </td>
	<td>(Numeric)</td>
	<td>Mean of the row means from the file body_gyro_y_merged.txt</td>
</tr>
<tr>
	<td>stddev_body_gyro_y </td>
	<td>(Numeric)</td>
	<td>Mean of the row standard deviations from the file body_gyro_y_merged.txt</td>
</tr>
<tr>
	<td>mean_body_gyro_z </td>
	<td>(Numeric)</td>
	<td>Mean of the row means from the file body_gyro_z_merged.txt</td>
</tr>
<tr>
	<td>stddev_body_gyro_z </td>
	<td>(Numeric)</td>
	<td>Mean of the row standard deviations from the file body_gyro_z_merged.txt</td>
</tr>
<tr>
	<td>mean_total_acc_x </td>
	<td>(Numeric)</td>
	<td>Mean of the row means from the file total_acc_x_merged.txt</td>
</tr>
<tr>
	<td>stddev_total_acc_x </td>
	<td>(Numeric)</td>
	<td>Mean of the row standard deviations from the file total_acc_x_merged.txt</td>
</tr>
<tr>
	<td>mean_total_acc_y</td>
	<td>(Numeric)</td>
	<td>Mean of the row means from the file total_acc_y_merged.txt</td>
</tr>
<tr>
	<td>stddev_total_acc_y</td>
	<td>(Numeric)</td>
	<td>Mean of the row standard deviations from the file total_acc_y_merged.txt </td>
</tr>
<tr>
	<td>mean_total_acc_z</td>
	<td>(Numeric)</td>
	<td>Mean of the row means from the file total_acc_z_merged.txt</td>
</tr>
<tr>
	<td>stddev_total_acc_z</td>
	<td>(Numeric)</td>
	<td>Mean of the row standard deviations from the file total_acc_z_merged.txt </td>
</tr>
</table>