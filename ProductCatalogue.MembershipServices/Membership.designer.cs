﻿#pragma warning disable 1591
//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by a tool.
//     Runtime Version:4.0.30319.42000
//
//     Changes to this file may cause incorrect behavior and will be lost if
//     the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace ProductCatalogue.MembershipServices
{
	using System.Data.Linq;
	using System.Data.Linq.Mapping;
	using System.Data;
	using System.Collections.Generic;
	using System.Reflection;
	using System.Linq;
	using System.Linq.Expressions;
	using System.ComponentModel;
	using System;
	
	
	[global::System.Data.Linq.Mapping.DatabaseAttribute(Name="ProductCatalogue4")]
	public partial class MembershipDataContext : System.Data.Linq.DataContext
	{
		
		private static System.Data.Linq.Mapping.MappingSource mappingSource = new AttributeMappingSource();
		
    #region Extensibility Method Definitions
    partial void OnCreated();
    partial void InsertUserRole(UserRole instance);
    partial void UpdateUserRole(UserRole instance);
    partial void DeleteUserRole(UserRole instance);
    partial void InsertUserProfileRole(UserProfileRole instance);
    partial void UpdateUserProfileRole(UserProfileRole instance);
    partial void DeleteUserProfileRole(UserProfileRole instance);
    partial void InsertUserProfile(UserProfile instance);
    partial void UpdateUserProfile(UserProfile instance);
    partial void DeleteUserProfile(UserProfile instance);
    #endregion
		
		public MembershipDataContext() : 
				base(global::ProductCatalogue.MembershipServices.Properties.Settings.Default.ProductCatalogue4ConnectionString, mappingSource)
		{
			OnCreated();
		}
		
		public MembershipDataContext(string connection) : 
				base(connection, mappingSource)
		{
			OnCreated();
		}
		
		public MembershipDataContext(System.Data.IDbConnection connection) : 
				base(connection, mappingSource)
		{
			OnCreated();
		}
		
		public MembershipDataContext(string connection, System.Data.Linq.Mapping.MappingSource mappingSource) : 
				base(connection, mappingSource)
		{
			OnCreated();
		}
		
		public MembershipDataContext(System.Data.IDbConnection connection, System.Data.Linq.Mapping.MappingSource mappingSource) : 
				base(connection, mappingSource)
		{
			OnCreated();
		}
		
		public System.Data.Linq.Table<UserRole> UserRoles
		{
			get
			{
				return this.GetTable<UserRole>();
			}
		}
		
		public System.Data.Linq.Table<UserProfileRole> UserProfileRoles
		{
			get
			{
				return this.GetTable<UserProfileRole>();
			}
		}
		
		public System.Data.Linq.Table<UserProfile> UserProfiles
		{
			get
			{
				return this.GetTable<UserProfile>();
			}
		}
		
		[global::System.Data.Linq.Mapping.FunctionAttribute(Name="dbo.GetRolesForUser")]
		public ISingleResult<GetRolesForUserResult> GetRolesForUser([global::System.Data.Linq.Mapping.ParameterAttribute(DbType="VarChar(50)")] string username)
		{
			IExecuteResult result = this.ExecuteMethodCall(this, ((MethodInfo)(MethodInfo.GetCurrentMethod())), username);
			return ((ISingleResult<GetRolesForUserResult>)(result.ReturnValue));
		}
	}
	
	[global::System.Data.Linq.Mapping.TableAttribute(Name="dbo.UserRole")]
	public partial class UserRole : INotifyPropertyChanging, INotifyPropertyChanged
	{
		
		private static PropertyChangingEventArgs emptyChangingEventArgs = new PropertyChangingEventArgs(String.Empty);
		
		private int _id;
		
		private string _roleName;
		
		private EntitySet<UserProfileRole> _UserProfileRoles;
		
    #region Extensibility Method Definitions
    partial void OnLoaded();
    partial void OnValidate(System.Data.Linq.ChangeAction action);
    partial void OnCreated();
    partial void OnidChanging(int value);
    partial void OnidChanged();
    partial void OnroleNameChanging(string value);
    partial void OnroleNameChanged();
    #endregion
		
		public UserRole()
		{
			this._UserProfileRoles = new EntitySet<UserProfileRole>(new Action<UserProfileRole>(this.attach_UserProfileRoles), new Action<UserProfileRole>(this.detach_UserProfileRoles));
			OnCreated();
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_id", AutoSync=AutoSync.OnInsert, DbType="Int NOT NULL IDENTITY", IsPrimaryKey=true, IsDbGenerated=true)]
		public int id
		{
			get
			{
				return this._id;
			}
			set
			{
				if ((this._id != value))
				{
					this.OnidChanging(value);
					this.SendPropertyChanging();
					this._id = value;
					this.SendPropertyChanged("id");
					this.OnidChanged();
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_roleName", DbType="NVarChar(50) NOT NULL", CanBeNull=false)]
		public string roleName
		{
			get
			{
				return this._roleName;
			}
			set
			{
				if ((this._roleName != value))
				{
					this.OnroleNameChanging(value);
					this.SendPropertyChanging();
					this._roleName = value;
					this.SendPropertyChanged("roleName");
					this.OnroleNameChanged();
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.AssociationAttribute(Name="UserRole_UserProfileRole", Storage="_UserProfileRoles", ThisKey="id", OtherKey="roleId")]
		public EntitySet<UserProfileRole> UserProfileRoles
		{
			get
			{
				return this._UserProfileRoles;
			}
			set
			{
				this._UserProfileRoles.Assign(value);
			}
		}
		
		public event PropertyChangingEventHandler PropertyChanging;
		
		public event PropertyChangedEventHandler PropertyChanged;
		
		protected virtual void SendPropertyChanging()
		{
			if ((this.PropertyChanging != null))
			{
				this.PropertyChanging(this, emptyChangingEventArgs);
			}
		}
		
		protected virtual void SendPropertyChanged(String propertyName)
		{
			if ((this.PropertyChanged != null))
			{
				this.PropertyChanged(this, new PropertyChangedEventArgs(propertyName));
			}
		}
		
		private void attach_UserProfileRoles(UserProfileRole entity)
		{
			this.SendPropertyChanging();
			entity.UserRole = this;
		}
		
		private void detach_UserProfileRoles(UserProfileRole entity)
		{
			this.SendPropertyChanging();
			entity.UserRole = null;
		}
	}
	
	[global::System.Data.Linq.Mapping.TableAttribute(Name="dbo.UserProfileRole")]
	public partial class UserProfileRole : INotifyPropertyChanging, INotifyPropertyChanged
	{
		
		private static PropertyChangingEventArgs emptyChangingEventArgs = new PropertyChangingEventArgs(String.Empty);
		
		private int _profileId;
		
		private int _roleId;
		
		private EntityRef<UserRole> _UserRole;
		
		private EntityRef<UserProfile> _UserProfile;
		
    #region Extensibility Method Definitions
    partial void OnLoaded();
    partial void OnValidate(System.Data.Linq.ChangeAction action);
    partial void OnCreated();
    partial void OnprofileIdChanging(int value);
    partial void OnprofileIdChanged();
    partial void OnroleIdChanging(int value);
    partial void OnroleIdChanged();
    #endregion
		
		public UserProfileRole()
		{
			this._UserRole = default(EntityRef<UserRole>);
			this._UserProfile = default(EntityRef<UserProfile>);
			OnCreated();
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_profileId", DbType="Int NOT NULL", IsPrimaryKey=true)]
		public int profileId
		{
			get
			{
				return this._profileId;
			}
			set
			{
				if ((this._profileId != value))
				{
					if (this._UserProfile.HasLoadedOrAssignedValue)
					{
						throw new System.Data.Linq.ForeignKeyReferenceAlreadyHasValueException();
					}
					this.OnprofileIdChanging(value);
					this.SendPropertyChanging();
					this._profileId = value;
					this.SendPropertyChanged("profileId");
					this.OnprofileIdChanged();
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_roleId", DbType="Int NOT NULL", IsPrimaryKey=true)]
		public int roleId
		{
			get
			{
				return this._roleId;
			}
			set
			{
				if ((this._roleId != value))
				{
					if (this._UserRole.HasLoadedOrAssignedValue)
					{
						throw new System.Data.Linq.ForeignKeyReferenceAlreadyHasValueException();
					}
					this.OnroleIdChanging(value);
					this.SendPropertyChanging();
					this._roleId = value;
					this.SendPropertyChanged("roleId");
					this.OnroleIdChanged();
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.AssociationAttribute(Name="UserRole_UserProfileRole", Storage="_UserRole", ThisKey="roleId", OtherKey="id", IsForeignKey=true)]
		public UserRole UserRole
		{
			get
			{
				return this._UserRole.Entity;
			}
			set
			{
				UserRole previousValue = this._UserRole.Entity;
				if (((previousValue != value) 
							|| (this._UserRole.HasLoadedOrAssignedValue == false)))
				{
					this.SendPropertyChanging();
					if ((previousValue != null))
					{
						this._UserRole.Entity = null;
						previousValue.UserProfileRoles.Remove(this);
					}
					this._UserRole.Entity = value;
					if ((value != null))
					{
						value.UserProfileRoles.Add(this);
						this._roleId = value.id;
					}
					else
					{
						this._roleId = default(int);
					}
					this.SendPropertyChanged("UserRole");
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.AssociationAttribute(Name="UserProfile_UserProfileRole", Storage="_UserProfile", ThisKey="profileId", OtherKey="id", IsForeignKey=true)]
		public UserProfile UserProfile
		{
			get
			{
				return this._UserProfile.Entity;
			}
			set
			{
				UserProfile previousValue = this._UserProfile.Entity;
				if (((previousValue != value) 
							|| (this._UserProfile.HasLoadedOrAssignedValue == false)))
				{
					this.SendPropertyChanging();
					if ((previousValue != null))
					{
						this._UserProfile.Entity = null;
						previousValue.UserProfileRoles.Remove(this);
					}
					this._UserProfile.Entity = value;
					if ((value != null))
					{
						value.UserProfileRoles.Add(this);
						this._profileId = value.id;
					}
					else
					{
						this._profileId = default(int);
					}
					this.SendPropertyChanged("UserProfile");
				}
			}
		}
		
		public event PropertyChangingEventHandler PropertyChanging;
		
		public event PropertyChangedEventHandler PropertyChanged;
		
		protected virtual void SendPropertyChanging()
		{
			if ((this.PropertyChanging != null))
			{
				this.PropertyChanging(this, emptyChangingEventArgs);
			}
		}
		
		protected virtual void SendPropertyChanged(String propertyName)
		{
			if ((this.PropertyChanged != null))
			{
				this.PropertyChanged(this, new PropertyChangedEventArgs(propertyName));
			}
		}
	}
	
	[global::System.Data.Linq.Mapping.TableAttribute(Name="dbo.UserProfile")]
	public partial class UserProfile : INotifyPropertyChanging, INotifyPropertyChanged
	{
		
		private static PropertyChangingEventArgs emptyChangingEventArgs = new PropertyChangingEventArgs(String.Empty);
		
		private int _id;
		
		private string _email;
		
		private string _passwordHash;
		
		private string _passwordSalt;
		
		private string _username;
		
		private System.DateTime _creationDate;
		
		private System.Nullable<int> _contactId;
		
		private string _password;
		
		private EntitySet<UserProfileRole> _UserProfileRoles;
		
    #region Extensibility Method Definitions
    partial void OnLoaded();
    partial void OnValidate(System.Data.Linq.ChangeAction action);
    partial void OnCreated();
    partial void OnidChanging(int value);
    partial void OnidChanged();
    partial void OnemailChanging(string value);
    partial void OnemailChanged();
    partial void OnpasswordHashChanging(string value);
    partial void OnpasswordHashChanged();
    partial void OnpasswordSaltChanging(string value);
    partial void OnpasswordSaltChanged();
    partial void OnusernameChanging(string value);
    partial void OnusernameChanged();
    partial void OncreationDateChanging(System.DateTime value);
    partial void OncreationDateChanged();
    partial void OncontactIdChanging(System.Nullable<int> value);
    partial void OncontactIdChanged();
    partial void OnpasswordChanging(string value);
    partial void OnpasswordChanged();
    #endregion
		
		public UserProfile()
		{
			this._UserProfileRoles = new EntitySet<UserProfileRole>(new Action<UserProfileRole>(this.attach_UserProfileRoles), new Action<UserProfileRole>(this.detach_UserProfileRoles));
			OnCreated();
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_id", AutoSync=AutoSync.OnInsert, DbType="Int NOT NULL IDENTITY", IsPrimaryKey=true, IsDbGenerated=true)]
		public int id
		{
			get
			{
				return this._id;
			}
			set
			{
				if ((this._id != value))
				{
					this.OnidChanging(value);
					this.SendPropertyChanging();
					this._id = value;
					this.SendPropertyChanged("id");
					this.OnidChanged();
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_email", DbType="NVarChar(50) NOT NULL", CanBeNull=false)]
		public string email
		{
			get
			{
				return this._email;
			}
			set
			{
				if ((this._email != value))
				{
					this.OnemailChanging(value);
					this.SendPropertyChanging();
					this._email = value;
					this.SendPropertyChanged("email");
					this.OnemailChanged();
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_passwordHash", DbType="NVarChar(100) NOT NULL", CanBeNull=false)]
		public string passwordHash
		{
			get
			{
				return this._passwordHash;
			}
			set
			{
				if ((this._passwordHash != value))
				{
					this.OnpasswordHashChanging(value);
					this.SendPropertyChanging();
					this._passwordHash = value;
					this.SendPropertyChanged("passwordHash");
					this.OnpasswordHashChanged();
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_passwordSalt", DbType="NVarChar(100) NOT NULL", CanBeNull=false)]
		public string passwordSalt
		{
			get
			{
				return this._passwordSalt;
			}
			set
			{
				if ((this._passwordSalt != value))
				{
					this.OnpasswordSaltChanging(value);
					this.SendPropertyChanging();
					this._passwordSalt = value;
					this.SendPropertyChanged("passwordSalt");
					this.OnpasswordSaltChanged();
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_username", DbType="NVarChar(50) NOT NULL", CanBeNull=false)]
		public string username
		{
			get
			{
				return this._username;
			}
			set
			{
				if ((this._username != value))
				{
					this.OnusernameChanging(value);
					this.SendPropertyChanging();
					this._username = value;
					this.SendPropertyChanged("username");
					this.OnusernameChanged();
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_creationDate", DbType="DateTime NOT NULL")]
		public System.DateTime creationDate
		{
			get
			{
				return this._creationDate;
			}
			set
			{
				if ((this._creationDate != value))
				{
					this.OncreationDateChanging(value);
					this.SendPropertyChanging();
					this._creationDate = value;
					this.SendPropertyChanged("creationDate");
					this.OncreationDateChanged();
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_contactId", DbType="Int")]
		public System.Nullable<int> contactId
		{
			get
			{
				return this._contactId;
			}
			set
			{
				if ((this._contactId != value))
				{
					this.OncontactIdChanging(value);
					this.SendPropertyChanging();
					this._contactId = value;
					this.SendPropertyChanged("contactId");
					this.OncontactIdChanged();
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_password", DbType="NVarChar(50)")]
		public string password
		{
			get
			{
				return this._password;
			}
			set
			{
				if ((this._password != value))
				{
					this.OnpasswordChanging(value);
					this.SendPropertyChanging();
					this._password = value;
					this.SendPropertyChanged("password");
					this.OnpasswordChanged();
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.AssociationAttribute(Name="UserProfile_UserProfileRole", Storage="_UserProfileRoles", ThisKey="id", OtherKey="profileId")]
		public EntitySet<UserProfileRole> UserProfileRoles
		{
			get
			{
				return this._UserProfileRoles;
			}
			set
			{
				this._UserProfileRoles.Assign(value);
			}
		}
		
		public event PropertyChangingEventHandler PropertyChanging;
		
		public event PropertyChangedEventHandler PropertyChanged;
		
		protected virtual void SendPropertyChanging()
		{
			if ((this.PropertyChanging != null))
			{
				this.PropertyChanging(this, emptyChangingEventArgs);
			}
		}
		
		protected virtual void SendPropertyChanged(String propertyName)
		{
			if ((this.PropertyChanged != null))
			{
				this.PropertyChanged(this, new PropertyChangedEventArgs(propertyName));
			}
		}
		
		private void attach_UserProfileRoles(UserProfileRole entity)
		{
			this.SendPropertyChanging();
			entity.UserProfile = this;
		}
		
		private void detach_UserProfileRoles(UserProfileRole entity)
		{
			this.SendPropertyChanging();
			entity.UserProfile = null;
		}
	}
	
	public partial class GetRolesForUserResult
	{
		
		private string _roleName;
		
		public GetRolesForUserResult()
		{
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_roleName", DbType="NVarChar(50) NOT NULL", CanBeNull=false)]
		public string roleName
		{
			get
			{
				return this._roleName;
			}
			set
			{
				if ((this._roleName != value))
				{
					this._roleName = value;
				}
			}
		}
	}
}
#pragma warning restore 1591
